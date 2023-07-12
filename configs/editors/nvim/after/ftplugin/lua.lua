-- https://GitHub.com/AlphaKeks/.dotfiles

source("~/.vim/after/ftplugin/lua.vim")

local lsp = require("alphakeks.lsp")

vim.lsp.start({
	name = "lua_ls",
	cmd = { "lua-language-server" },
	capabilities = lsp.capabilities,
	root_dir = vim.fs.dirname(
		vim.fs.find({ "lua" }, { upward = true })[1]
	),

	settings = {
		Lua = {
			telemetry = {
				enable = false,
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[expand("$VIMRUNTIME/lua")] = true,
					[expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
			}
		},
	},
})
