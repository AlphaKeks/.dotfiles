local separator = '%#StatusLineSeparator#█'

local modes = {
	["n"] = "normal",
	["no"] = "op",
	["nov"] = "op",
	["noV"] = "op",
	["no"] = "op",
	["niI"] = "normal",
	["niR"] = "normal",
	["niV"] = "normal",
	["v"] = "visual",
	["vs"] = "visual",
	["V"] = "lines",
	["Vs"] = "lines",
	[""] = "block",
	["s"] = "block",
	["s"] = "select",
	["S"] = "select",
	[""] = "block",
	["i"] = "insert",
	["ic"] = "insert",
	["ix"] = "insert",
	["R"] = "replace",
	["Rc"] = "replace",
	["Rv"] = "v-replace",
	["Rx"] = "replace",
	["c"] = "command",
	["cv"] = "command",
	["ce"] = "command",
	["r"] = "enter",
	["rm"] = "more",
	["r?"] = "confirm",
	["!"] = "shell",
	["t"] = "term",
	["nt"] = "term",
	["null"] = "none",
}

local lsp_messages = {}

LeftStatusLine = function()
	local mode = nvim_get_mode().mode
	local mode_text = modes[mode]

	return separator .. " %#StatusLineText#" .. mode_text
end

RightStatusLine = function()
	local diagnostics = {}

	local errors = #vim.diagnostic.get(0, { severity = 1 })
	if errors > 0 then
		table.insert(diagnostics, "%#DiagnosticSignError#  " .. tostring(errors))
	end

	local warnings = #vim.diagnostic.get(0, { severity = 2 })
	if warnings > 0 then
		table.insert(diagnostics, "%#DiagnosticSignWarn#  " .. tostring(warnings))
	end

	local infos = #vim.diagnostic.get(0, { severity = 3 })
	if infos > 0 then
		table.insert(diagnostics, "%#DiagnosticSignInfo#  " .. tostring(infos))
	end

	local hints = #vim.diagnostic.get(0, { severity = 4 })
	if hints > 0 then
		table.insert(diagnostics, "%#DiagnosticSignHint#  " .. tostring(hints))
	end

	for message in vim.gsplit(vim.lsp.status(), ", ") do
		table.insert(lsp_messages, message)
	end

	local diagnostic_counts = table.concat(diagnostics, " ")
	local ruler = string.format("%d:%d", line("."), col("."))
	local lsp_message = if_nil(table.remove(lsp_messages, 1), ""):gsub("%%", "%%%%")

	return lsp_message
			.. "%S  "
			.. diagnostic_counts
			.. " %#StatusLineText#"
			.. ruler
			.. " "
			.. separator
end

nvim_set_hl(0, "StatusLineSeparator", { fg = Dawn.lavender, bg = Dawn.crust })
nvim_set_hl(0, "StatusLineText", { fg = Dawn.text, bg = Dawn.crust })

vim.opt.showmode = false
vim.opt.statusline = "%{%v:lua.LeftStatusLine()%} %= %{%v:lua.RightStatusLine()%}"
