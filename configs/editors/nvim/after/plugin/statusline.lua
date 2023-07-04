-- https://GitHub.com/AlphaKeks/.dotfiles

Statusline = {
	separator = "%#StatusSeparator#█",

	modes = {
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
	},

	diagnostic_opts = {
		{ severity = 4, name = "Hint",  icon = "  " },
		{ severity = 3, name = "Info",  icon = "  " },
		{ severity = 2, name = "Warn",  icon = "  " },
		{ severity = 1, name = "Error", icon = "  " },
	},

	lsp_messages = {},
}

function Statusline:mode()
	local mode = vim.fn.mode()
	return self.modes[mode] or "UNK"
end

function Statusline:diagnostics()
	local diagnostics = ""

	for _, opts in ipairs(self.diagnostic_opts) do
		local count = vim.tbl_count(vim.diagnostic.get(0, { severity = opts.severity }))
		if count > 0 then
			diagnostics = string.format(
				"%s%%#StatusDiagnosticSign%s#%s%s ",
				diagnostics,
				opts.name,
				count,
				opts.icon
			)
		end
	end

	return diagnostics
end

function Statusline:lsp_info()
	local lsp_status = vim.lsp.status()

	for message in vim.gsplit(lsp_status, ", ") do
		table.insert(self.lsp_messages, message)
	end

	local latest_message = table.remove(self.lsp_messages, 1)

	return "%#StatusMode#" .. latest_message:gsub("%%", "%%%%")
end

function LeftStatusline()
	return string.format("%s %s", Statusline.separator, Statusline:mode())
end

function RightStatusline()
	return string.format(
		"%s %s %s",
		Statusline:lsp_info(),
		Statusline:diagnostics(),
		Statusline.separator
	)
end

function Winbar()
	local path = vim.fn.expand("%:p:.")
	return string.format("%%#StatusWinbar#%s", path)
end

function Statusline:setup()
	vim.opt.showmode = false
	vim.opt.statusline = "%{%v:lua.LeftStatusline()%} %= %{%v:lua.RightStatusline()%}"
	vim.opt.winbar = "%{%v:lua.Winbar()%}"

	vim.api.nvim_set_hl(0, "StatusSeparator", { fg = Dawn.lavender, bg = Dawn.crust })
	vim.api.nvim_set_hl(0, "StatusMode", { fg = Dawn.text, bg = Dawn.crust, bold = true })
	vim.api.nvim_set_hl(0, "StatusGitBranch", { fg = Dawn.mauve, bg = Dawn.crust })
	vim.api.nvim_set_hl(0, "StatusWinbar", { link = "WinBar" })
	vim.api.nvim_set_hl(0, "StatusDiagnosticSignHint", { fg = Dawn.teal, bg = Dawn.crust })
	vim.api.nvim_set_hl(0, "StatusDiagnosticSignInfo", { fg = Dawn.green, bg = Dawn.crust })
	vim.api.nvim_set_hl(0, "StatusDiagnosticSignWarn", { fg = Dawn.yellow, bg = Dawn.crust })
	vim.api.nvim_set_hl(0, "StatusDiagnosticSignError", { fg = Dawn.red, bg = Dawn.crust })
end

Statusline:setup()
