autocmd("TermOpen", {
	command = "setlocal nonumber relativenumber scrolloff=0 statuscolumn=",
})

usercmd("Term", function()
	tabe()
	term()
	startinsert()
end, {
	desc = "Opens a terminal in a new tab",
})

usercmd("LG", function()
	vim.cmd.Term()
	input("lg<CR>")
end, {
	desc = "Opens a terminal with lazygit in a new tab",
})
