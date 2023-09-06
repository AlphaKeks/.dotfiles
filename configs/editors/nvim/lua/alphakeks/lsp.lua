local LSP = {}

LSP.augroups = {
	on_attach = augroup("lsp-on-attach"),
	on_save = augroup("lsp-on-save"),
	highlights = augroup("lsp-highlights"),
	progress = augroup("lsp-progress"),
}

LSP.capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
	textDocument = {
		completion = {
			dynamicRegistration = false,
			completionItem = {
				snippetSupport = false,
				commitCharactersSupport = true,
				deprecatedSupport = true,
				preselectSupport = false,
				tagSupport = {
					valueSet = { 1 },
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
					valueSet = { 1, 2 },
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

LSP.find_root = function(pattern, find_dir)
	find_dir = if_nil(find_dir, false)

	local matches = vim.fs.find(pattern, {
		upward = true,
		type = find_dir and "directory" or "file",
	})

	if not find_dir then
		return vim.fs.dirname(matches[1])
	end

	return matches[1]
end

LSP.keymaps = function(buffer)
	buffer = if_nil(buffer, nvim_get_current_buf())

	local bufmap = function(modes, lhs, rhs)
		return keymap(modes, lhs, rhs, { buffer = buffer })
	end

	bufmap("n", "ga", vim.lsp.buf.code_action)
	bufmap("n", "gd", vim.lsp.buf.definition)
	bufmap("n", "<Leader><Leader>", vim.lsp.buf.hover)
	bufmap("n", "gi", vim.lsp.buf.implementation)
	bufmap("n", "gR", vim.lsp.buf.references)
	bufmap("i", "<C-h>", vim.lsp.buf.signature_help)
	bufmap("n", "gD", vim.lsp.buf.type_definition)
	bufmap("n", "gs", vim.lsp.buf.workspace_symbol)

	bufmap("n", "gr", function()
		vim.ui.input({ prompt = "Rename > " }, function(input)
			if input then
				vim.lsp.buf.rename(input)
			end
		end)
	end)

	bufmap("n", "gI", function()
		pcall(vim.lsp.buf.inlay_hint, buffer)
	end)
end

LSP.format_on_save = function(buffer)
	buffer = if_nil(buffer, nvim_get_current_buf())

	autocmd("BufWritePre", {
		group = LSP.augroups.on_save,
		buffer = buffer,
		desc = "Formats the current buffer using LSP before saving",
		callback = function(event)
			vim.lsp.buf.format({ bufnr = event.buf })
		end,
	})
end

LSP.highlights = function(buffer)
	buffer = if_nil(buffer, nvim_get_current_buf())

	autocmd({ "CursorMoved", "CursorMovedI" }, {
		group = LSP.augroups.highlights,
		buffer = buffer,
		desc = "Highlights the word under the cursor and all references to it",
		callback = function(event)
			local treesitter_installed, treesitter = pcall(require, "nvim-treesitter.ts_utils")

			if not treesitter_installed then
				vim.warn("treesitter is not installed")
				nvim_clear_autocmds({ buffer = event.buf, group = LSP.augroups.highlights })

				return
			end

			local current_node = treesitter.get_node_at_cursor()

			if not current_node then
				vim.lsp.buf.clear_references()
				return
			end

			local node_text = vim.treesitter.get_node_text(current_node, event.buf)

			if vim.g.CURRENT_NODE == node_text then
				return
			end

			vim.lsp.buf.clear_references()
			vim.g.CURRENT_NODE = node_text

			if current_node:type() == "identifier" or current_node:type() == "property_identifier" then
				vim.lsp.buf.document_highlight()
			end
		end,
	})
end

LSP.disable_semantic_highlights = function(client)
	client.server_capabilities.semanticTokensProvider = nil
	return client
end

autocmd("LspAttach", {
	group = LSP.augroups.on_attach,
	desc = "Runs once when a language server attaches",
	callback = function(event)
		LSP.keymaps(event.buf)

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		assert(client)

		local is_tsserver = client.name == "tsserver"
		local supports_formatting = client.server_capabilities.documentFormattingProvider
		local supports_highlighting = client.server_capabilities.documentHighlightProvider
		local supports_completion = client.server_capabilities.completionProvider

		if not is_tsserver and supports_formatting then
			LSP.format_on_save(event.buf)
		end

		if supports_highlighting then
			LSP.highlights(event.buf)
		end

		if supports_completion then
			vim.bo[event.buf].omnifunc = require("alphakeks.completion")
		end

		command("LspInfo", function()
			local clients = vim.lsp.get_clients({ bufnr = event.buf })
			local list = "Attached LSP Servers:"

			for _, client in ipairs(clients) do
				list = list .. string.format("\n• %s (%d)", client.name, client.id)
			end

			SendToQf(list)
		end, { buffer = true })

		command("LspLog", function(cmd)
			local log_path = stdpath("state") .. "/lsp.log"

			if #cmd.args == 0 or cmd.args == "edit" then
				edit(log_path)
			elseif cmd.args == "clean" then
				System({ "rm", log_path }, function(result)
					System({ "touch", log_path })
					vim.info("Cleaned LSP log.")
				end)
			end
		end, {
			buffer = true,
			nargs = "?",
			complete = function(input)
				return vim.tbl_filter(function(item)
					return vim.starts_with(item, input)
				end, { "edit", "clean" })
			end,
		})

		command("LspFormat", function()
			vim.lsp.buf.format({ bufnr = event.buf })
		end, { buffer = true })
	end,
})

autocmd("LspProgress", {
	group = LSP.augroups.progress,
	desc = "Refreshes the statusline when LSP updates come in",
	callback = function()
		redrawstatus()
	end,
})

return LSP

-- vim: foldmethod=indent foldlevel=0
