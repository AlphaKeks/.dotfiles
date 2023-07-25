autocmd("FileType", {
	pattern = { "yml", "yaml" },
	callback = function()
		vim.bo.tabstop = 69
		vim.bo.shiftwidth = 69
		print("hello yyaml")
	end,
})
