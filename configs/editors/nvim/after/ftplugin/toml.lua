vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2

local lsp = require("alphakeks.lsp")

vim.lsp.start({
	name = "taplo",
	cmd = { "taplo", "lsp", "stdio" },
	capabilities = lsp.capabilities,
	root_dir = lsp.find_root({ "*.toml" }),
})
