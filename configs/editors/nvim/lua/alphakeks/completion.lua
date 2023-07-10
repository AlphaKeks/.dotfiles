-- WIP

Balls = {
	capabilities = {
		textDocument = {
			completion = {
				dynamicRegistration = true,
				completionItem = {
					snippetSupport = false,
					commitCharactersSupport = true,
					deprecatedSupport = true,
					preselectSupport = true,
					tagSupport = {
						valueSet = {
							1, -- Deprecated
						}
					},
					insertReplaceSupport = false,
					resolveSupport = {
						properties = {
							"documentation",
							"detail",
							"additionalTextEdits",
							"sortText",
							"filterText",
							"insertText",
							"textEdit",
							"insertTextFormat",
							"insertTextMode",
						},
					},
					insertTextModeSupport = {
						valueSet = {
							1, -- asIs
							2, -- adjustIndentation
						}
					},
					labelDetailsSupport = true,
				},
				contextSupport = true,
				insertTextMode = 1,
				completionList = {
					itemDefaults = {
						"commitCharacters",
						"editRange",
						"insertTextFormat",
						"insertTextMode",
						"data",
					}
				}
			},
		},
	}
}

local function get_cursor_col()
	return vim.api.nvim_win_get_cursor(0)[2]
end

local function get_chars_under_cursor()
	local line = vim.api.nvim_get_current_line()
	local cursor_col = get_cursor_col()
	local char = line:sub(cursor_col, cursor_col)
	local chars = line:sub(cursor_col - 1, cursor_col)
	return char, chars
end

local function is_variable(str)
	return str:match("[%a_]")
end

local function is_whitespace(str)
	return str:match("%s")
end

local function should_trigger_lsp_completion(str)
	local triggers = {
		rust = { ".", "::" },
		lua = { ".", ":" },
		javascript = { "." },
		typescript = { "." },
	}

	for _, trigger in ipairs(triggers[vim.o.filetype] or {}) do
		if trigger == str then
			return true
		end
	end

	return false
end

local function draw_docs_window(word, docs, doc_kind)
	local doc_lines = {}

	for line in vim.gsplit(docs, "\n") do
		table.insert(doc_lines, line)
	end

	local pum = vim.fn.pum_getpos()
	local max_width = vim.o.columns - ((pum.col or 0) + (pum.width or 0))
	local max_height = vim.o.lines - (pum.row or 0)
	local offset_x = (pum.width or 0) - word:len() + 1
	local docs_empty = #doc_lines == 0 or doc_lines[1] == ""

	if not docs_empty then
		local bufnr = vim.lsp.util.open_floating_preview(doc_lines, doc_kind, {
			max_width = max_width,
			max_height = max_height,
			offset_x = offset_x,
			close_events = { "CompleteDone" },
			focusable = false,
			focus = false,
		})

		Balls.latest_doc_buf = bufnr
	end
end

local function press(key)
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes(key, true, false, true),
		"n",
		false
	)
end

local ignored_filetypes = {
	"TelescopePrompt",
}

function BallsCompletion(findstart, _)
	if findstart ~= 0 then
		for col = get_cursor_col(), 1, -1 do
			local char, chars = get_chars_under_cursor()
			local char_should_trigger = should_trigger_lsp_completion(char)
			local chars_should_trigger = should_trigger_lsp_completion(chars)

			vim.print(string.format(
				"char: `%s` (%s) | chars: `%s` (%s) | col: %s",
				char, char_should_trigger,
				chars, chars_should_trigger,
				col
			))

			if char_should_trigger or chars_should_trigger then
				return col
			end
		end

		return 1
	end

	local words = {}
	local params = vim.lsp.util.make_position_params()
	local result, err = vim.lsp.buf_request_sync(0, "textDocument/completion", params)

	if err then
		vim.g.latest_error = string.format(
			"Completion Request failed. err = %s",
			vim.inspect(err)
		)

		vim.notify(vim.g.latest_error, vim.log.levels.ERROR)
		return
	end

	if not (result and result[1] and result[1].result and result[1].result.items) then
		vim.g.latest_error = string.format(
			"Missing completion response. result = %s",
			vim.inspect(result)
		)

		vim.notify(vim.g.latest_error, vim.log.levels.ERROR)
		return
	end

	for _, item in ipairs(result[1].result.items) do
		local abbr = item.label or item.filterText or ""
		local word = item.data
				and item.data.entryNames
				and item.data.entryNames[1]
				or (item.textEdit and item.textEdit.newText)
				or abbr
		local user_data = { doc_text = "", import_path = nil }

		if item.documentation and item.documentation.value then
			user_data.doc_text = item.documentation.value

			if item.documentation.kind then
				Balls.doc_kind = item.documentation.kind
			end
		end

		if item.data and item.data.imports and item.data.imports[1] then
			user_data.import_path = item.data.imports[1].full_import_path
		end

		table.insert(words, { word = word, abbr = abbr, user_data = user_data })
	end

	return { words = words }
end

autocmd({ "VimEnter", "BufNew" }, {
	desc = "BallsCompletion",
	callback = function(args)
		vim.bo[args.buf].completefunc = "v:lua.BallsCompletion"

		autocmd({ "TextChangedI", "TextChangedP" }, {
			desc = "BallsCompletion",
			buffer = args.buf,
			callback = function()
				if vim.tbl_contains(ignored_filetypes, vim.o.filetype) then
					return
				end

				local char, chars = get_chars_under_cursor()
				if not char then
					return
				end

				if vim.fn.pumvisible() ~= 0 then
					return
				end

				if is_whitespace(char) then
					return
				end

				-- if is_variable(char) then
				-- 	if is_whitespace(chars:sub(1, 1)) then
				-- 		press("<C-x><C-u>")
				-- 	else
				-- 		press("<C-n>")
				-- 	end
				-- elseif should_trigger_lsp_completion(char) or should_trigger_lsp_completion(chars) then
				-- 	press("<C-x><C-u>")
				-- end

				if is_variable(char) then
					press("<C-x><C-u>")
				end
			end,
		})

		autocmd("CompleteChanged", {
			desc = "BallsCompletion",
			buffer = args.buf,
			callback = function()
				local completed_item = vim.deepcopy(vim.v.event.completed_item)
				if completed_item and completed_item.user_data then
					if completed_item.user_data.import_path then
						Balls.import_path = completed_item.user_data.import_path
					else
						Balls.import_path = nil
					end

					if completed_item.user_data.doc_text and completed_item.word then
						vim.schedule(function()
							draw_docs_window(
								completed_item.word,
								completed_item.user_data.doc_text,
								Balls.doc_kind or "markdown"
							)
						end)
					end
				end
			end,
		})

		vim.keymap.set("i", "<CR>", function()
			if vim.fn.pumvisible() ~= 0 then
				if Balls.latest_doc_buf then
					vim.api.nvim_buf_delete(Balls.latest_doc_buf, {})
				end

				if Balls.import_path then
					local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
					local above_last_import = 0
					local import_keywords = {
						rust = "use",
					}

					for i, line in ipairs(lines) do
						if line:match(import_keywords[vim.o.filetype]) then
							above_last_import = i - 1
						end
					end

					local import_statement = vim.print(string.format("use %s;", Balls.import_path))

					vim.schedule(function()
						vim.api.nvim_buf_set_lines(
							args.buf,
							above_last_import,
							above_last_import,
							false,
							{ import_statement, "" }
						)

						Balls.import_path = nil

						press("a")
					end)

					vim.cmd.stopinsert()
				end

				return "<C-y>"
			else
				return "<C-j>"
			end
		end, { buffer = args.buf, expr = true })
	end,
})

return Balls
