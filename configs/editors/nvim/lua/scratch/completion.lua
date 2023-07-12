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
	},

	triggers = {
		rust = { ".", "::" },
		lua = { ".", ":" },
		javascript = { "." },
		typescript = { "." },
	},

	import_keywords = {
		rust = "use",
	},

	doc_lines = {},

	ignored_filetypes = {
		"TelescopePrompt",
	},

	words = {},
}

function Balls:get_cursor_col()
	return win_get_cursor(0)[2]
end

function Balls:get_chars_under_cursor(col)
	local line = get_current_line()
	local cursor_col = col or self:get_cursor_col()
	local char = line:sub(cursor_col, cursor_col)
	local chars = line:sub(cursor_col - 1, cursor_col)
	return char, chars
end

function Balls:is_variable(str)
	return str:match("[%a_]")
end

function Balls:is_whitespace(str)
	return str:match("%s")
end

function Balls:should_trigger_lsp_completion(str)
	for _, trigger in ipairs(self.triggers[vim.o.filetype] or {}) do
		if trigger == str or self:is_whitespace(str) then
			return true
		end
	end

	return false
end

function Balls:draw_docs_window(word, docs, doc_kind)
	self.doc_lines = {}

	for line in vim.gsplit(docs, "\n") do
		table.insert(self.doc_lines, line)
	end

	local pum = pum_getpos()
	local max_width = vim.o.columns - ((pum.col or 0) + (pum.width or 0))
	local max_height = vim.o.lines - (pum.row or 0)
	local offset_x = (pum.width or 0) - word:len() + 1
	local docs_empty = #self.doc_lines == 0 or self.doc_lines[1] == ""

	if not docs_empty then
		self.latest_doc_buf = vim.schedule(function()
			vim.lsp.util.open_floating_preview(self.doc_lines, doc_kind, {
				max_width = max_width,
				max_height = max_height,
				offset_x = offset_x,
				close_events = { "CompleteDone", "CursorMoved", },
				focusable = false,
				focus = false,
			})
		end)
	end
end

function Balls:press(key)
	feedkeys(
		replace_termcodes(key, true, false, true),
		"n",
		false
	)
end

function Balls:params()
	return vim.lsp.util.make_position_params()
end

function Balls:import()
end

function BallsCompletion(findstart, _)
	if findstart ~= 0 then
		-- vim.trace("findstart")

		for col = Balls:get_cursor_col(), 1, -1 do
			local char, chars = Balls:get_chars_under_cursor(col)
			local char_should_trigger = Balls:should_trigger_lsp_completion(char)
			local chars_should_trigger = Balls:should_trigger_lsp_completion(chars)

			-- vim.trace(string.format(
			-- 	"char: `%s` (%s) | chars: `%s` (%s) | col: %s",
			-- 	char, char_should_trigger,
			-- 	chars, chars_should_trigger,
			-- 	col
			-- ))

			if Balls:is_whitespace(char) or char_should_trigger or chars_should_trigger then
				-- vim.trace("start at col " .. tostring(col))
				return col
			end
		end

		-- vim.trace("did not find start")
		return -1
	end

	local words = {}
	local params = Balls:params()

	-- vim.trace("making completion request")
	local result, err = vim.lsp.buf_request_sync(0, "textDocument/completion", params)
	-- vim.trace("done making completion request")

	if err then
		vim.g.latest_error = string.format(
			"Completion Request failed. err = %s",
			vim.inspect(err)
		)

		vim.error(vim.g.latest_error)
		return
	end

	if not (result and result[1] and result[1].result and result[1].result.items) then
		vim.g.latest_error = string.format(
			"Missing completion response. result = %s",
			vim.inspect(result)
		)

		vim.error(vim.g.latest_error)
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

		-- vim.trace("returning completions")
		table.insert(words, { word = word, abbr = abbr, user_data = user_data })
	end

	return { words = words }
end

function Balls:setup()
	autocmd({ "VimEnter", "BufNew" }, {
		desc = "BallsCompletion",
		callback = function(args)
			vim.bo[args.buf].completefunc = "v:lua.BallsCompletion"

			-- Trigger completion on every keypress
			autocmd({ "TextChangedI", "TextChangedP" }, {
				desc = "BallsCompletion",
				buffer = args.buf,
				callback = function()
					if vim.tbl_contains(Balls.ignored_filetypes, vim.o.filetype) then
						return
					end

					local char, chars = Balls:get_chars_under_cursor()
					if not char then
						return
					end

					if Balls:is_whitespace(char) then
						return
					end

					if pumvisible() == 0 and Balls:is_variable(char) then
						Balls:press("<C-x><C-u>")
					else
						if Balls:is_variable(char)
								or Balls:should_trigger_lsp_completion(char)
								or Balls:should_trigger_lsp_completion(chars)
						then
							Balls:press("<C-x><C-u>")
						end
					end
				end,
			})

			-- Show documentation when cycling through suggestions
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
								Balls:draw_docs_window(
									completed_item.word,
									completed_item.user_data.doc_text,
									Balls.doc_kind or "markdown"
								)
							end)
						end
					end
				end,
			})

			-- `Enter` for accepting completion suggestions
			vim.keymap.set("i", "<CR>", function()
				if pumvisible() == 0 then
					return "<C-j>"
				end

				if Balls.import_path then
					local import_keyword = Balls.import_keywords[vim.o.filetype]
					local buf_lines = buf_get_lines(0, 0, -1, false)
					local start = 0

					for line_nr, line in ipairs(buf_lines) do
						if line:match(import_keyword) then
							start = line_nr - 1
						end
					end

					local import_statement = string.format("%s %s;", import_keyword, Balls.import_path)

					vim.schedule_wrap(function()
						buf_set_lines(0, start, start, false, { import_statement, "" })
						Balls.import_path = nil
						Balls:press("a")
					end)

					stopinsert()
				end

				return "<C-y>"
			end, { buffer = 0, expr = true })
		end,
	})
end

return Balls
