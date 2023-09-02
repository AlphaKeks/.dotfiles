local lsp = require("alphakeks.lsp")

vim.lsp.start({
	name = "svelte-language-server",
	cmd = { "svelteserver", "--stdio" },
	capabilities = lsp.capabilities,
	root_dir = lsp.find_root({ "package.json" }),
})
