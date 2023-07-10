-- https://GitHub.com/AlphaKeks/.dotfiles

local M = {
	augroups = {
		global = augroup("lsp-on-attach"),
		progress = augroup("lsp-progress"),
		format_on_save = augroup("lsp-format-on-save"),
		inlay_hints = augroup("lsp-inlay-hints"),
	},

	capabilities = vim.lsp.protocol.make_client_capabilities(),

	keymaps = function(bufnr)
		local function bmap(modes, lhs, rhs)
			vim.keymap.set(modes, lhs, rhs, { buffer = bufnr, silent = true })
		end

		bmap("n", "gd", vim.lsp.buf.definition)
		bmap("n", "gD", vim.lsp.buf.type_definition)
		bmap("n", "<Leader><Leader>", vim.lsp.buf.hover)
		bmap("n", "ga", vim.lsp.buf.code_action)
		bmap("n", "gr", vim.lsp.buf.rename)
		bmap("n", "gR", vim.lsp.buf.references)
		bmap("n", "gi", vim.lsp.buf.implementation)
		bmap("n", "<Leader>gi", function() vim.lsp.inlay_hint(0) end)
		bmap("i", "<C-h>", vim.lsp.buf.signature_help)
	end,
}

M.format_on_save = function(bufnr)
	autocmd("BufWritePre", {
		group = M.augroups.format_on_save,
		buffer = bufnr,
		callback = function()
			if not pcall(vim.lsp.buf.format) then
				vim.notify("Failed to format buffer.", vim.log.levels.ERROR)
			end
		end,
	})
end

M.inlay_hints = function(bufnr)
	if not pcall(vim.lsp.inlay_hint, bufnr, true) then
		vim.notify("Failed to activate inlay hints.", vim.log.levels.ERROR)
	end

	-- Toggle inlay hints when entering / leaving insert mode
	-- autocmd({ "InsertEnter", "InsertLeave" }, {
	-- 	group = M.augroups.inlay_hints,
	-- 	buffer = bufnr,
	-- 	callback = function()
	-- 		if not pcall(vim.lsp.inlay_hint, bufnr) then
	-- 			vim.notify("Failed to toggle inlay hints.", vim.log.levels.ERROR)
	-- 		end
	-- 	end,
	-- })
end

M.highlight_word = function(bufnr)
	autocmd({ "CursorMoved", "CursorMovedI" }, {
		group = M.augroups.global,
		buffer = bufnr,
		callback = function()
			local utils = require("nvim-treesitter.ts_utils")
			local current_node = utils.get_node_at_cursor()

			if not current_node then
				return
			end

			local node_text = vim.treesitter.get_node_text(current_node, bufnr)

			if vim.g.current_node ~= node_text then
				vim.g.current_node = node_text
				vim.lsp.buf.clear_references(bufnr)

				local node_type = vim.treesitter.get_node():type()

				if node_type == "identifier" or node_type == "property_identifier" then
					vim.lsp.buf.document_highlight()
				end
			end
		end,
	})
end

local cmp_installed, cmp_capabilities = pcall(require, "cmp_nvim_lsp")
if cmp_installed then
	M.capabilities = vim.tbl_deep_extend(
		"force",
		M.capabilities,
		cmp_capabilities.default_capabilities()
	)
else
	M.capabilities = vim.tbl_deep_extend(
		"force",
		M.capabilities,
		require("alphakeks.completion").capabilities
	)
end

M.configs = {
	typescript = function()
		return {
			name = "tsserver",
			cmd = { "typescript-language-server", "--stdio" },
			capabilities = M.capabilities,
			root_dir = vim.fs.dirname(
				vim.fs.find({ ".git", "package.json" }, { upward = true })[1]
			),

			init_options = {
				hostInfo = "neovim",
				preferences = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
					importModuleSpecifierPreference = "non-relative",
				},
			},
		}
	end,
}

autocmd("LspAttach", {
	group = M.augroups.global,
	callback = function(args)
		M.keymaps(args.buf)

		-- LSP omni-completion
		vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		usercmd("Format", function()
			if not pcall(vim.lsp.buf.format) then
				vim.notify("Failed to format buffer.", vim.log.levels.ERROR)
			end
		end)

		usercmd("LspLog", function(args)
			local args = args.args
			local log_path = os.getenv("HOME") .. "/.local/state/nvim/lsp.log"

			if args:len() == 0 then
				vim.cmd.edit(log_path)
			elseif args == "edit" then
				vim.cmd.edit(log_path)
			elseif args == "clean" then
				vim.fn.system({ "echo", "''", ">", log_path })
			else
				vim.notify("`" .. args .. "` is not a valid argument.", vim.log.levels.ERROR)
			end
		end, {
			nargs = "?",
			complete = function()
				return { "edit", "clean" }
			end,
		})

		usercmd("LspInfo", function()
			local servers = vim.lsp.get_active_clients()
			local list = "Attached LSP Servers:"

			for _, server in ipairs(servers) do
				list = string.format("%s\n • %s (%s)", list, server.name, server.id)
			end

			print(list)
		end)

		local client = vim.lsp.get_client_by_id(args.data.client_id)
		-- print("LSP capabilities: " .. vim.inspect(client.server_capabilities))

		if client.server_capabilities.documentFormattingProvider then
			M.format_on_save(args.buf)
		end

		-- if client.server_capabilities.inlayHintProvider then
		-- 	M.inlay_hints(args.buf)
		-- end

		if client.server_capabilities.documentHighlightProvider then
			M.highlight_word(args.buf)
		end
	end,
})

autocmd("LspProgress", {
	group = M.augroups.progress,
	callback = function()
		vim.cmd.redrawstatus()
	end,
})

return M
