_G.Winbar = function()
	return string.format(
		"%%#StatusWinbar#%s  %s",
		expand("%:p:."),
		ShowKeys.winbar and ShowKeys.text or ""
	)
end

vim.opt.winbar = "%{%v:lua.Winbar()%}"
