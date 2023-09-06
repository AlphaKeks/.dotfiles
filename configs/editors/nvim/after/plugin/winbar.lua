Winbar = function()
	local path = expand("%:p:.")

	return "%#WinBar#" .. path
end

vim.opt.winbar = "%{%v:lua.Winbar()%}"
