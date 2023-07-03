-- https://GitHub.com/AlphaKeks/.dotfiles

autocmd = vim.api.nvim_create_autocmd
augroup = function(name, opts)
	return vim.api.nvim_create_augroup(name, opts or { clear = true })
end

function usercmd(name, callback, opts)
	vim.api.nvim_create_user_command(name, callback, opts or {})
end

