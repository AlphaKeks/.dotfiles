vim.diagnostic.config({
	underline = true,

	virtual_text = {
		severity = vim.diagnostic.severity.ERROR,
		source = false,
		prefix = "",
		suffix = "",
		update_in_insert = true,
	},

	float = {
		focusable = true,
		source = "always",
		prefix = "",
		border = "single",
	},
})

keymap("n", "gl", vim.diagnostic.open_float)
keymap("n", "gL", vim.diagnostic.goto_next)
