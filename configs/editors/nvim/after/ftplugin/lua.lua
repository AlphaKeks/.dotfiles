source("~/.vim/after/ftplugin/lua.vim")

local lsp = require("lsp")

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
					expand("$VIMRUNTIME/lua"),
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
