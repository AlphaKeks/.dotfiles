-- https://GitHub.com/AlphaKeks/.dotfiles

vim.opt.showmode = false

local modes = {
	['n']     = 'NORMAL',
	['no']    = 'O-PENDING',
	['nov']   = 'O-PENDING',
	['noV']   = 'O-PENDING',
	['no\22'] = 'O-PENDING',
	['niI']   = 'NORMAL',
	['niR']   = 'NORMAL',
	['niV']   = 'NORMAL',
	['nt']    = 'NORMAL',
	['ntT']   = 'NORMAL',
	['v']     = 'VISUAL',
	['vs']    = 'VISUAL',
	['V']     = 'V-LINE',
	['Vs']    = 'V-LINE',
	['\22']   = 'V-BLOCK',
	['\22s']  = 'V-BLOCK',
	['s']     = 'SELECT',
	['S']     = 'S-LINE',
	['\19']   = 'S-BLOCK',
	['i']     = 'INSERT',
	['ic']    = 'INSERT',
	['ix']    = 'INSERT',
	['R']     = 'REPLACE',
	['Rc']    = 'REPLACE',
	['Rx']    = 'REPLACE',
	['Rv']    = 'V-REPLACE',
	['Rvc']   = 'V-REPLACE',
	['Rvx']   = 'V-REPLACE',
	['c']     = 'COMMAND',
	['cv']    = 'EX',
	['ce']    = 'EX',
	['r']     = 'REPLACE',
	['rm']    = 'MORE',
	['r?']    = 'CONFIRM',
	['!']     = 'SHELL',
	['t']     = 'TERMINAL',
}

local function mode()
	return modes[vim.fn.mode()] or "UNK"
end

local function diagnostics()
	local diagnostics = ""

	local hints = vim.tbl_count(vim.diagnostic.get(0, { severity = 4 }))
	if hints > 0 then
		diagnostics = diagnostics .. "%#DiagnosticSignHint#" .. tostring(hints) .. "  "
	end

	local infos = vim.tbl_count(vim.diagnostic.get(0, { severity = 3 }))
	if infos > 0 then
		diagnostics = diagnostics .. "%#DiagnosticSignInfo#" .. tostring(infos) .. "  "
	end

	local warns = vim.tbl_count(vim.diagnostic.get(0, { severity = 2 }))
	if warns > 0 then
		diagnostics = diagnostics .. "%#DiagnosticSignWarn#" .. tostring(warns) .. "  "
	end

	local errors = vim.tbl_count(vim.diagnostic.get(0, { severity = 1 }))
	if errors > 0 then
		diagnostics = diagnostics .. "%#DiagnosticSignError#" .. tostring(errors) .. "  "
	end

	return diagnostics
end

local function lsp_info()
	return "%#StatusMode#" .. vim.lsp.status():gsub("%%", "%%%%")
end

function LeftStatusline()
	local sep = "%#StatusSeparator#█"
	local mode = "%#StatusMode# " .. mode()
	return string.format("%s%s", sep, mode)
end

function RightStatusline()
	return string.format("%s %s %%#StatusSeparator#█", lsp_info(), diagnostics())
end

function Winbar()
	local path = vim.fn.expand("%:p:~")
	return string.format("%%#StatusWinbar#%s", path)
end

hi(0, "StatusSeparator", { fg = Dawn.lavender, bg = Dawn.crust })
hi(0, "StatusMode", { fg = Dawn.text, bg = Dawn.crust, bold = true })
hi(0, "StatusGitBranch", { fg = Dawn.mauve, bg = Dawn.crust })
hi(0, "StatusWinbar", { link = "WinBar" })

vim.opt.statusline = "%{%v:lua.LeftStatusline()%} %= %{%v:lua.RightStatusline()%}"
vim.opt.winbar = "%{%v:lua.Winbar()%}"

