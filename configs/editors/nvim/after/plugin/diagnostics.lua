vim.diagnostic.config({
	underline = false,

	-- virtual_text = {
	-- 	severity = vim.diagnostic.severity.ERROR,
	-- 	source = false,
	-- 	prefix = "",
	-- 	suffix = "",
	-- 	update_in_insert = true,
	-- },

	virtual_text = false,

	float = {
		focusable = true,
		source = "always",
		prefix = "",
		border = "single",
	},
})

keymap("n", "gl", vim.diagnostic.open_float)
keymap("n", "]d", vim.diagnostic.goto_next)
keymap("n", "[d", vim.diagnostic.goto_prev)
