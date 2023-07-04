-- https://GitHub.com/AlphaKeks/.dotfiles

local lsp = require("alphakeks.lsp")

vim.lsp.start({
	name = "taplo",

	cmd = { "taplo", "lsp", "stdio" },

	capabilities = lsp.capabilities,

	root_dir = vim.fs.dirname(
		vim.fs.find({ "*.toml" }, { upward = true })[1]
	),
})
