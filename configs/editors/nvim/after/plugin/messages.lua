usercmd("Messages", function()
	vim.cmd("redir => g:messages | silent messages | redir END")
	SendToQf(vim.g.messages, "Messages")
end, {
	desc = "Inserts all :messages into the quickfix list and opens it",
})
