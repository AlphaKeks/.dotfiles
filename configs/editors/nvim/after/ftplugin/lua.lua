-- https://GitHub.com/AlphaKeks/.dotfiles

vim.cmd.source("~/.vim/after/ftplugin/lua.vim")

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
		},
	},

	before_init = require("neodev.lsp").before_init,

	on_attach = function()
		print("lua_ls attached!")
	end,
})
