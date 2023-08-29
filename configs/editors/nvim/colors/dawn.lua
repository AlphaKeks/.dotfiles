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

_G.hi = function(group, opts)
	nvim_set_hl(0, group, opts or {})
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
	blend = 10,
})

hi("FloatBorder", {
	fg = Dawn.subtext0,
	bg = Dawn.none,
	blend = 10,
})

hi("FloatTitle", {
	fg = Dawn.blue,
	bg = Dawn.none,
	blend = 10,
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
	fg = Dawn.pink,
	bold = true,
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
	fg = Dawn.flamingo,
	bold = true,
	italic = true,
})

hi("@constructor.lua", {
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

hi("@text.reference", {
	fg = Dawn.mauve,
	bold = true,
})

hi("@text.danger.comment", {
	fg = Dawn.red,
	bold = true,
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

hi("@lsp.type.generic", {
	link = "Type",
})

hi("@lsp.type.keyword", {
	link = "Keyword",
})

hi("@lsp.type.namespace", {
	link = "@namespace",
})

hi("@lsp.type.number", {
	link = "Number",
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

hi("@lsp.type.punctuation", {
	link = "Delimiter",
})

hi("@lsp.type.selfKeyword", {
	fg = Dawn.red,
})

hi("@lsp.type.string", {
	link = "String",
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

hi("@lsp.typemod.function", {
	link = "Function",
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

hi("@lsp.typemod.variable.constant", {
	link = "@lsp.mod.constant",
})

hi("@lsp.typemod.variable.global", {
	fg = Dawn.red,
})

hi("@lsp.typemod.function.global", {
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
	fg = Dawn.sapphire,
})

hi("NeogitRemote", {
	fg = Dawn.mauve,
})

hi("NeogitUntrackedFiles", {
	fg = Dawn.green,
})

hi("NeogitUnstagedChanges", {
	fg = Dawn.red,
})

hi("NeogitRecentcommits", {
	fg = Dawn.yellow,
})

hi("NeogitDiffAdd", {
	fg = Dawn.green,
})

hi("NeogitDiffDelete", {
	fg = Dawn.red,
})

hi("NeogitHunkHeader", {
	fg = Dawn.blue,
	bold = true,
})

-- }}}

-- vim: foldmethod=marker foldlevel=0
