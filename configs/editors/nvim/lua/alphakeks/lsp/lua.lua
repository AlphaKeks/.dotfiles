local lsp = require("alphakeks.lsp")

return {
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
					[expand("$VIMRUNTIME/lua")] = true,
					[expand("$VIMRUNTIME/lua/vim/lsp")] = true,
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
}
