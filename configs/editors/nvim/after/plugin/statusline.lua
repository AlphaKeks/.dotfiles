local separator = "%#StatusSeparator#█"

local modes = {
	["n"] = "NORMAL",
	["no"] = "O-PENDING",
	["nov"] = "O-PENDING",
	["noV"] = "O-PENDING",
	["no\22"] = "O-PENDING",
	["niI"] = "NORMAL",
	["niR"] = "NORMAL",
	["niV"] = "NORMAL",
	["nt"] = "NORMAL",
	["ntT"] = "NORMAL",
	["v"] = "VISUAL",
	["vs"] = "VISUAL",
	["V"] = "V-LINE",
	["Vs"] = "V-LINE",
	["\22"] = "V-BLOCK",
	["\22s"] = "V-BLOCK",
	["s"] = "SELECT",
	["S"] = "S-LINE",
	["\19"] = "S-BLOCK",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["ix"] = "INSERT",
	["R"] = "REPLACE",
	["Rc"] = "REPLACE",
	["Rx"] = "REPLACE",
	["Rv"] = "V-REPLACE",
	["Rvc"] = "V-REPLACE",
	["Rvx"] = "V-REPLACE",
	["c"] = "COMMAND",
	["cv"] = "EX",
	["ce"] = "EX",
	["r"] = "REPLACE",
	["rm"] = "MORE",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
}

local diagnostic_opts = {
	{ severity = 4, name = "Hint",  icon = "  " },
	{ severity = 3, name = "Info",  icon = "  " },
	{ severity = 2, name = "Warn",  icon = "  " },
	{ severity = 1, name = "Error", icon = "  " },
}

local lsp_messages = {}

local modules = {
	mode = function()
		return modes[mode()] or "UNK"
	end,

	diagnostics = function()
		local str = ""

		for _, opts in ipairs(diagnostic_opts) do
			local count = #vim.diagnostic.get(0, { severity = opts.severity })
			if count > 0 then
				str = string.format("%s%%#StatusDiagnosticSign%s#%s%s ", str, opts.name, count, opts.icon)
			end
		end

		return str
	end,

	lsp_info = function()
		for message in vim.gsplit(vim.lsp.status(), ", ") do
			table.insert(lsp_messages, message)
		end

		local latest_message = table.remove(lsp_messages, 1) or ""
		return "%#StatusMode#" .. latest_message:gsub("%%", "%%%%")
	end,
}

function LeftStatusline()
	return ("%s %s"):format(separator, modules:mode())
end

function RightStatusline()
	return ("%s %s %s"):format(modules:lsp_info(), modules:diagnostics(), separator)
end

vim.opt.showmode = false
vim.opt.statusline = "%{%v:lua.LeftStatusline()%} %= %{%v:lua.RightStatusline()%}"

set_hl(0, "StatusSeparator", { fg = Dawn.lavender, bg = Dawn.crust })
set_hl(0, "StatusMode", { fg = Dawn.text, bg = Dawn.crust, bold = true })
set_hl(0, "StatusGitBranch", { fg = Dawn.mauve, bg = Dawn.crust })
set_hl(0, "StatusWinbar", { link = "WinBar" })
set_hl(0, "StatusDiagnosticSignHint", { fg = Dawn.teal, bg = Dawn.crust })
set_hl(0, "StatusDiagnosticSignInfo", { fg = Dawn.green, bg = Dawn.crust })
set_hl(0, "StatusDiagnosticSignWarn", { fg = Dawn.yellow, bg = Dawn.crust })
set_hl(0, "StatusDiagnosticSignError", { fg = Dawn.red, bg = Dawn.crust })
