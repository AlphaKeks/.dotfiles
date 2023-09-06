vim.diagnostic.config({
	underline = false,
	virtual_text = false,
	update_in_insert = true,
	severity_sort = true,

	float = {
		severity_sort = true,
		header = "Diagnostics",
		source = "if_many",
		prefix = "• ",
	},
})

keymap("n", "gl", vim.diagnostic.open_float)
keymap("n", "[d", vim.diagnostic.goto_prev)
keymap("n", "]d", vim.diagnostic.goto_next)
