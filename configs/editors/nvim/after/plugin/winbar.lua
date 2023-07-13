function Winbar()
	return ("%%#StatusWinbar#%s"):format(expand("%:p:."))
end

vim.opt.winbar = "%{%v:lua.Winbar()%}"
