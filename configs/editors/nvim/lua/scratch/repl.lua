_G.LuaRepl = function()
	local callback = function(text)
		local result = eval(text)
		append(line("$") - 1, result)
	end

	new()
	vim.bo.buftype = "prompt"
	prompt_setcallback(bufnr(), callback)
	keymap("n", "<ESC>", "<CMD>bw!<CR>", { buffer = true, silent = true })
	startinsert()
end

usercmd("Repl", LuaRepl, { desc = "Opens a Lua REPL" })
