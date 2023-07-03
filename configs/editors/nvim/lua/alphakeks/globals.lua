-- https://GitHub.com/AlphaKeks/.dotfiles

function nn(lhs, rhs, opts)
	vim.keymap.set("n", lhs, rhs, opts or { silent = true })
end

function Print(...)
	vim.print(vim.inspect(...))
	return ...
end

autocmd = vim.api.nvim_create_autocmd
augroup = function(name, opts)
	return vim.api.nvim_create_augroup(name, opts or { clear = true })
end

function usercmd(name, callback, opts)
	vim.api.nvim_create_user_command(name, callback, opts or {})
end

