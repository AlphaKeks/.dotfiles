-- https://GitHub.com/AlphaKeks/.dotfiles

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
		border = "solid",
	},
})

vim.keymap.set("n", "gl", vim.diagnostic.open_float)
vim.keymap.set("n", "gL", vim.diagnostic.goto_next)
