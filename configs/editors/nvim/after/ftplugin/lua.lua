source("~/.vim/after/ftplugin/lua.vim")

local lsp = require("alphakeks.lsp")

vim.lsp.start({
	name = "lua_ls",
	cmd = { "lua-language-server" },
	capabilities = lsp.capabilities,
	root_dir = lsp.find_root({ "lua" }),
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},

			workspace = {
				library = {
					vim.env.VIMRUNTIME,
					stdpath("config") .. "/lua",
				},
			},

			diagnostics = {
				globals = { "vim", "awesome" },
			},

			telemetry = {
				enable = false,
			},
		},
	},
})
