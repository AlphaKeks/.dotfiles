-- Name:          dawn.nvim
-- Author:        AlphaKeks <alphakeks@dawn.sh>
-- Maintainer:    AlphaKeks <alphakeks@dawn.sh>
-- Repository:    https://github.com/AlphaKeks/.dotfiles
-- License:       MIT
--
-- Color palette: https://github.com/catppuccin/nvim
--   rosewater -> "#F5E0DC"
--   flamingo  -> "#F2CDCD"
--   pink      -> "#F5C2E7"
--   mauve     -> "#CBA6F7"
--   red       -> "#F38BA8"
--   maroon    -> "#EBA0AC"
--   peach     -> "#FAB387"
--   yellow    -> "#F9E2AF"
--   green     -> "#A6E3A1"
--   teal      -> "#94E2D5"
--   sky       -> "#89DCEB"
--   sapphire  -> "#74C7EC"
--   blue      -> "#89B4FA"
--   lavender  -> "#B4BEFE"
--   text      -> "#CDD6F4"
--   subtext1  -> "#BAC2DE"
--   subtext0  -> "#A6ADC8"
--   overlay2  -> "#9399B2"
--   overlay1  -> "#7F849C"
--   overlay0  -> "#6C7086"
--   surface2  -> "#585B70"
--   surface1  -> "#45475A"
--   surface0  -> "#313244"
--   base      -> "#1E1E2E"
--   mantle    -> "#181825"
--   crust     -> "#11111B"
--   none      -> "NONE"
--
-- These are my own (͡ ͡° ͜ つ ͡͡°)
--   slate     -> "#3C5E7F"
--   poggers   -> "#7480C2"

source("~/.vim/colors/dawn.vim")
vim.g.colors_name = "dawn"

function hi(group, opts)
	set_hl(0, group, opts or {})
end

-- {{{ Colors

Dawn = {
	rosewater = "#F5E0DC",
	flamingo  = "#F2CDCD",
	pink      = "#F5C2E7",
	mauve     = "#CBA6F7",
	red       = "#F38BA8",
	maroon    = "#EBA0AC",
	peach     = "#FAB387",
	yellow    = "#F9E2AF",
	green     = "#A6E3A1",
	teal      = "#94E2D5",
	sky       = "#89DCEB",
	sapphire  = "#74C7EC",
	blue      = "#89B4FA",
	lavender  = "#B4BEFE",

	text      = "#CDD6F4",
	subtext1  = "#BAC2DE",
	subtext0  = "#A6ADC8",
	overlay2  = "#9399B2",
	overlay1  = "#7F849C",
	overlay0  = "#6C7086",
	surface2  = "#585B70",
	surface1  = "#45475A",
	surface0  = "#313244",

	base      = "#1E1E2E",
	mantle    = "#181825",
	crust     = "#11111B",

	none      = "NONE",
	slate     = "#3C5E7F",
	poggers   = "#7480C2",
}

-- }}}

-- {{{ Editor

hi("DiagnosticOk", {
	fg = Dawn.green,
})

hi("DiagnosticHint", {
	fg = Dawn.teal,
})

hi("DiagnosticInfo", {
	fg = Dawn.green,
})

hi("DiagnosticWarn", {
	fg = Dawn.yellow,
})

hi("DiagnosticError", {
	fg = Dawn.red,
})

hi("DiagnosticDeprecated", {
	fg = Dawn.slate,
	italic = true,
})

hi("DiagnosticUnderlineOk")
hi("DiagnosticUnderlineHint")
hi("DiagnosticUnderlineInfo")
hi("DiagnosticUnderlineWarn")
hi("DiagnosticUnderlineError")
hi("DiagnosticUnderlineDeprecated")

hi("NormalFloat", {
	fg = Dawn.text,
	bg = Dawn.none,
	blend = 20,
})

hi("FloatBorder", {
	fg = Dawn.lavender,
	bg = Dawn.none,
	blend = 20,
})

hi("FloatTitle", {
	fg = Dawn.blue,
	bg = Dawn.none,
	blend = 20,
})

hi("WinBar", {
	fg = Dawn.sapphire,
	italic = true,
})

hi("WinBarNC", {
	link = "WinBar",
})

hi("WinSeparator", {
	fg = Dawn.text,
	bg = Dawn.none,
})

hi("LspInlayHint", {
	fg = Dawn.slate,
	italic = true,
})

hi("LspReferenceText", {
	fg = Dawn.yellow,
	bg = Dawn.surface0,
	italic = true,
})

hi("LspReferenceRead", {
	link = "LspReferenceText",
})

hi("LspReferenceWrite", {
	link = "LspReferenceText",
})

--- }}}

-- {{{ Treesitter

hi("@constructor", {
	link = "Delimiter",
})

-- For enums
hi("@constant.builtin.rust", {
	link = "@constant",
})

hi("@field", {
	fg = Dawn.lavender,
})

hi("@function.builtin", {
	fg = Dawn.peach,
})

hi("@namespace", {
	fg = Dawn.blue,
})

hi("@parameter", {
	fg = Dawn.maroon,
})

hi("@property", {
	fg = Dawn.red,
})

hi("@variable.builtin", {
	fg = Dawn.peach,
})

-- }}}

-- {{{ LSP Semantic Highlights

hi("@lsp.mod.attribute", {
	link = "Delimiter",
})

hi("@lsp.mod.crateRoot", {
	fg = Dawn.red,
	bold = true,
})

hi("@lsp.mod.controlFlow", {
	link = "Conditional",
})

hi("@lsp.mod.constant", {
	link = "Constant",
})

hi("@lsp.mod.defaultLibrary", {
	fg = Dawn.peach,
})

hi("@lsp.mod.definition", {
	fg = Dawn.red,
})

hi("@lsp.mod.library", {
	fg = Dawn.blue,
})

hi("@lsp.type.enumMember", {
	fg = Dawn.peach,
})

hi("@lsp.type.formatSpecifier", {
	link = "Delimiter",
})

hi("@lsp.type.namespace", {
	link = "@namespace",
})

hi("@lsp.type.operator", {
	link = "Operator",
})

hi("@lsp.type.parameter", {
	fg = Dawn.maroon,
})

hi("@lsp.type.property", {
	fg = Dawn.lavender,
})

hi("@lsp.type.selfKeyword", {
	fg = Dawn.red,
})

hi("@lsp.type.typeAlias", {
	link = "Type",
})

hi("@lsp.typemod.decorator.attribute", {
	link = "Function",
})

hi("@lsp.typemod.derive", {
	link = "@lsp.typemod.interface",
})

hi("@lsp.typemod.enum", {
	link = "Type",
})

hi("@lsp.typemod.enumMember", {
	link = "@lsp.type.enumMember",
})

hi("@lsp.typemod.interface", {
	fg = Dawn.flamingo,
	bold = true,
	italic = true,
})

hi("@lsp.typemod.macro", {
	link = "Macro",
})

hi("@lsp.typemod.method", {
	link = "Function",
})

hi("@lsp.typemod.namespace.crateRoot", {
	link = "@lsp.mod.crateRoot",
})

hi("@lsp.typemod.namespace.defaultLibrary")

hi("@lsp.typemod.namespace.library", {
	link = "@namespace",
})

hi("@lsp.typemod.property", {
	link = "@lsp.type.property",
})

hi("@lsp.typemod.struct", {
	link = "Type",
})

hi("@lsp.typemod.typeAlias", {
	link = "Type",
})

hi("@lsp.typemod.variable.global", {
	fg = Dawn.red,
})

-- }}}

-- {{{ Telescope

hi("TelescopePromptCounter", {
	link = "Text",
})

hi("TelescopeSelection", {
	link = "CursorLine",
})

-- }}}

-- {{{ Neogit

hi("NeogitBranch", {
	fg = Dawn.pink,
})

hi("NeogitRemote", {
	fg = Dawn.pink,
})

hi("NeogitHunkHeader", {
	fg = Dawn.blue,
	bg = Dawn.base,
})

hi("NeogitHunkHeaderHighlight", {
	link = "NeogitHunkHeader",
})

hi("NeogitDiffContext", {
	fg = Dawn.text,
	bg = Dawn.base,
})

hi("NeogitDiffContextHighlight", {
	link = "NeogitDiffContext",
})

hi("NeogitDiffAdd", {
	fg = Dawn.green,
	bg = Dawn.base,
})

hi("NeogitDiffDelete", {
	fg = Dawn.red,
	bg = Dawn.base,
})

hi("NeogitDiffAddHighlight", {
	link = "NeogitDiffAdd",
})

hi("NeogitDiffDeleteHighlight", {
	link = "NeogitDiffDelete",
})

hi("NeogitCommitViewHeader", {
	fg = Dawn.blue,
	bg = Dawn.base,
})

hi("NeogitNotificationInfo", {
	fg = Dawn.blue,
})

hi("NeogitNotificationWarn", {
	fg = Dawn.yellow,
})

hi("NeogitNotificationError", {
	fg = Dawn.red,
})

-- }}}

-- vim: foldmethod=marker foldlevel=0
