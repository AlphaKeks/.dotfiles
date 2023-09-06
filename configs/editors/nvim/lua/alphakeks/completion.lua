local METHOD = "textDocument/completion"
local fzf = require("fzf_lib")

---@class Completion
---@field word string The text that will be inserted
---@field abbr string? Abbreviation of `word`. If this exists, it will be preferred over `word`.
---@field menu string? Extra text to be displayed in the completion menu
---@field info string? Extra information that can be displayed in a preview window
---@field kind string? Single letter indicating the type of completion
---@field icase integer? When non-zero: ignore case when completing. Defaults to 0.
---@field equal integer? When non-zero: always treat this item as a match
---@field dup integer? When non-zero: allow this item to show up multiple times
---@field empty integer? When non-zero: allow this item to show up even if it's empty
---@field user_data any? Custom data that will be stored in `vim.v.completed_item`

---@param findstart 0 | 1
---@param base string?
---@return integer | { words: Completion[], refresh: "always" }
function BallsCompletion(findstart, base)
	local buffer_id = nvim_get_current_buf()
	local window_id = nvim_get_current_win()
	local cursor_column = nvim_win_get_cursor(window_id)[2]
	local current_line = nvim_get_current_line():sub(1, cursor_column)
	local start_column = match(current_line, "\\k*$") + 1

	---@type Completion[]
	local words = {}

	local callback = function()
		local mode = nvim_get_mode().mode
		if mode == "i" or mode == "ic" then
			complete(start_column, words)
		end
	end

	local clients = vim.lsp.get_clients({
		bufnr = buffer_id,
		method = METHOD,
	})

	if #clients == 0 then
		if findstart == 1 then
			return -1
		else
			return {}
		end
	end

	for _, client in ipairs(clients) do
		local params = vim.lsp.util.make_position_params(window_id, client.offset_encoding)

		client.request(METHOD, params, function(error, result)
			if error then
				return vim.error("Error requesting LSP completions: %s", vim.inspect(error))
			end

			if not result then
				return vim.warn("No LSP completions.")
			end

			local mode = nvim_get_mode().mode
			if not (mode == "i" or mode == "ic") then
				return
			end

			if not base or #base == 0 then
				base = current_line:sub(start_column)
			end

			local slab = fzf.allocate_slab()
			local pattern_obj = fzf.parse_pattern(base, 0)

			for _, item in ipairs(result.items) do
				local word = nil

				if item.textEdit and item.textEdit.newText then
					word = item.textEdit.newText
				elseif item.insertText then
					word = item.insertText
				end

				if not word then
					goto continue
				end

				-- I hate typescript.
				if vim.startswith(word, ".") then
					word = word:sub(2)
				end

				local score = fzf.get_score(word, pattern_obj, slab)

				if #base > 0 and score == 0 then
					goto continue
				end

				-- lua_ls is really slow on this for some reason
				if vim.o.filetype ~= "lua" then
					local extra_info = vim.lsp.buf_request_sync(buffer_id, "completionItem/resolve", item)

					if extra_info
							and extra_info[1]
							and extra_info[1].result
					then
						item = vim.tbl_deep_extend("force", item, extra_info[1].result)
					end
				end

				---@type Completion
				local completion = {
					word = word,
					icase = 69,
					user_data = {
						detail = item.detail,
						score = score,
					},
				}

				if item.documentation and item.documentation.value then
					completion.info = item.documentation.value
				end

				if item.data
						and item.data.imports
						and item.data.imports[1]
						and item.data.imports[1].full_import_path
				then
					completion.user_data.import_path = item.data.imports[1].full_import_path
				end

				if item.label ~= word then
					completion.menu = item.label:gsub(word, "", 1)
				end

				table.insert(words, completion)

				::continue::
			end

			table.sort(words, function(a, b)
				if a.user_data.score == b.user_data.score then
					return #a.word < #b.word
				else
					return a.user_data.score > b.user_data.score
				end
			end)

			fzf.free_pattern(pattern_obj)
			fzf.free_slab(slab)

			vim.schedule(callback)
		end, buffer_id)
	end

	return -2
end

local group = augroup("alphakeks-completion")

autocmd("CompleteChanged", {
	group = group,
	desc = "Documentation popup when scrolling completion suggestions",
	callback = function(event)
		local clients = vim.lsp.get_clients({
			bufnr = event.buf,
			method = METHOD,
		})

		if #clients == 0 then
			return
		end

		local event_data = vim.deepcopy(vim.v.event)
		local completion = event_data.completed_item --[[@as Completion]]
		local max_length = 0
		local has_detail = completion.user_data
				and completion.user_data.detail
				and #completion.user_data.detail > 0

		if has_detail then
			max_length = #completion.user_data.detail
		end

		local documentation = vim.tbl_map(function(line)
			max_length = math.min(math.max(max_length, #line), 100)
			return line
		end, vim.split(if_nil(completion.info, ""), "\n"))

		if max_length == 0 then
			return
		end

		if has_detail then
			local header = {
				"",
				string.rep("-", max_length),
				"```",
			}

			for line in vim.gsplit(completion.user_data.detail, "\n") do
				table.insert(header, 4, line)
			end

			table.insert(header, "```" .. vim.o.filetype)

			for _, line in ipairs(header) do
				table.insert(documentation, 1, line)
			end
		end

		local float_opts = {
			height = math.min(#documentation, math.floor(vim.o.lines / 2)),
			width = max_length,
			offset_x = event_data.width - #(if_nil(completion.word, "")) + 1,
			close_events = { "CompleteChanged", "CompleteDone", "InsertLeave" },
			focusable = false,
			focus = false,
		}

		vim.schedule(function()
			vim.lsp.util.open_floating_preview(documentation, "markdown", float_opts)
		end)
	end,
})

keymap("i", "<CR>", function()
	if pumvisible() == 0 then
		nvim_feedkeys(nvim_replace_termcodes("<CR>", true, false, true), "n", false)
		return
	end

	nvim_input("<C-y>")

	local completion = complete_info({ "items", "selected" })
	local item = completion.items[completion.selected + 1] --[[@as Completion]]
	local import_path = item.user_data.import_path

	if not import_path then
		return
	end

	local import_prefix = nil
	local import_text = nil
	local ft = vim.o.filetype

	if ft == "rust" then
		import_prefix = "use"
		import_text = string.format("use %s;", import_path)
	end

	if not (import_prefix and import_text) then
		return
	end

	local lines = nvim_buf_get_lines(0, 0, -1, false)

	for idx, line in ipairs(lines) do
		if vim.startswith(line, import_prefix) then
			nvim_buf_set_lines(0, idx - 1, idx - 1, false, { import_text })
			return
		end
	end

	for idx, line in ipairs(lines) do
		if not vim.startswith(line, "//") then
			nvim_buf_set_lines(0, idx - 1, idx - 1, false, { import_text, "" })
			return
		end
	end

	nvim_buf_set_lines(0, 0, 0, false, { import_text, "" })
end, { buffer = true })

return "v:lua.BallsCompletion"
