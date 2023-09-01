local M = {}

M.find_root = function(pattern)
	local files = vim.fs.find(pattern, { upward = true })
	return vim.fs.dirname(files[1])
end

M.augroups = {
	on_attach = augroup("lsp-on-attach"),
	format_on_save = augroup("lsp-format-on-save"),
	highlight_word = augroup("lsp-highlight-word"),
	progress = augroup("lsp-progress-updates"),
	inlay_hints = augroup("lsp-inlay-hints"),
}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

local cmp_installed, cmp = pcall(require, "cmp_nvim_lsp")

if cmp_installed then
	M.capabilities = vim.tbl_deep_extend("force", M.capabilities, cmp.default_capabilities())
else
	M.capabilities = vim.tbl_deep_extend("force", M.capabilities, {
		textDocument = {
			completion = {
				dynamicRegistration = false,
				completionItem = {
					snippetSupport = false,
					commitCharactersSupport = true,
					deprecatedSupport = true,
					preselectSupport = false,
					tagSupport = {
						valueSet = {
							1, -- Deprecated
						},
					},
					insertReplaceSupport = true,
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
						},
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
					},
				}
			},
		},
	})
end

local lsp_format = function()
	if not pcall(vim.lsp.buf.format) then
		vim.error("Failed to format buffer.")
	end
end

M.format_on_save = function(bufnr)
	autocmd("BufWritePre", {
		desc = "Format the current buffer on save via LSP",
		group = M.augroups.format_on_save,
		buffer = bufnr,
		callback = lsp_format,
	})
end

local toggle_inlay_hints = function(bufnr)
	if not pcall(vim.lsp.inlay_hint, bufnr) then
		vim.error("Failed to toggle inlay hints in buffer %s", bufnr)
	end
end

M.setup_keymaps = function(bufnr)
	local bmap = function(modes, lhs, rhs)
		return keymap(modes, lhs, rhs, { buffer = bufnr, silent = true })
	end

	bmap("n", "gd", vim.lsp.buf.definition)
	bmap("n", "gD", vim.lsp.buf.type_definition)
	bmap("n", "<Leader><Leader>", vim.lsp.buf.hover)
	bmap("n", "ga", vim.lsp.buf.code_action)
	bmap("n", "gr", vim.lsp.buf.rename)
	bmap("n", "gR", vim.lsp.buf.references)
	bmap("n", "gi", vim.lsp.buf.implementation)
	bmap("n", "<Leader>gi", function() toggle_inlay_hints(0) end)
	bmap("i", "<C-h>", vim.lsp.buf.signature_help)
end

M.inlay_hints = function(buf)
	buf = if_nil(buf, bufnr())

	toggle_inlay_hints(buf)

	-- autocmd({ "InsertLeave", "InsertEnter" }, {
	-- 	desc = "Toggle Inlay Hints when leaving / entering insert mode",
	-- 	group = M.augroups.inlay_hints,
	-- 	buffer = bufnr,
	-- 	callback = function()
	-- 		toggle_inlay_hints(bufnr)
	-- 	end,
	-- })
end

M.highlight_word = function(bufnr)
	autocmd({ "CursorMoved", "CursorMovedI" }, {
		desc = "Highlights the word under the cursor and all other occurrences of it",
		group = M.augroups.highlight_word,
		buffer = bufnr,
		callback = function()
			local ts_installed, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
			if not ts_installed then
				vim.warn("Treesitter is not installed.")
				nvim_clear_autocmds({ buffer = bufnr, group = M.augroups.highlight_word })
				return
			end

			local current_node = ts_utils.get_node_at_cursor()
			if not current_node then
				vim.lsp.buf.clear_references()
				return
			end

			local node_text = vim.treesitter.get_node_text(current_node, bufnr)
			if CURRENT_NODE == node_text then
				return
			end

			vim.lsp.buf.clear_references()
			CURRENT_NODE = node_text

			local node_type = vim.treesitter.get_node():type()
			if node_type == "identifier" or node_type == "property_identifier" then
				vim.lsp.buf.document_highlight()
			end
		end,
	})
end

autocmd("LspAttach", {
	group = M.augroups.on_attach,
	callback = function(cmd)
		M.setup_keymaps(cmd.buf)

		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "single",
		})

		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "single",
		})

		local client = vim.lsp.get_client_by_id(cmd.data.client_id)
		-- SendToQf(client)

		if not client then
			return
		end

		if client.server_capabilities.documentFormattingProvider
				and client.name ~= "tsserver" -- We like prettier more
		then
			M.format_on_save(cmd.buf)
		end

		-- if client.server_capabilities.inlayHintProvider then
		-- 	M.inlay_hints(opts.buf)
		-- end

		if client.server_capabilities.documentHighlightProvider then
			M.highlight_word(cmd.buf)
		end

		usercmd("LspFormat", lsp_format, { desc = "Formats the current buffer via LSP" })

		buf_usercmd(cmd.buf, "LspLog", function(cmd)
			local arg = cmd.args
			local log_path = stdpath("state") .. "/lsp.log"

			if #arg == 0 or arg == "edit" then
				edit(log_path)
			elseif arg == "qf" then
				local lines = ""

				for _, line in ipairs(readfile(log_path)) do
					for subline in vim.gsplit(line, "\\n") do
						lines = lines .. "\n\n" .. subline
					end
				end

				SendToQf(lines)
			elseif arg == "clean" then
				System({ "rm", log_path }, function()
					System({ "touch", log_path })
					vim.info("Successfully cleaned LSP log.")
				end)
			else
				vim.error("`%s` is not a valid argument.", arg)
			end
		end, {
			desc = "view / edit / clean the LSP log file",
			nargs = "?",
			complete = function()
				return { "edit", "qf", "clean" }
			end,
		})

		buf_usercmd(cmd.buf, "LspInfo", function()
			local servers = vim.lsp.get_clients()
			local list = "Attached LSP Servers:"

			for _, server in ipairs(servers) do
				list = string.format("%s\n • %s (%s)", list, server.name, server.id)
			end

			SendToQf(list)
		end, { desc = "Shows currently active LSP servers" })
	end,
})

autocmd("LspProgress", {
	group = M.augroups.progress,
	callback = function()
		redrawstatus()
	end,
})

return M
