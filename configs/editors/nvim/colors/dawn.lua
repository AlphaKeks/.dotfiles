-- Name:          dawn.nvim
-- Author:        AlphaKeks <alphakeks@dawn.sh>
-- Maintainer:    AlphaKeks <alphakeks@dawn.sh>
-- Repository:    https://github.com/AlphaKeks/.dotfiles
-- License:       MIT
-- Color palette: https://github.com/catppuccin/nvim

vim.cmd([[
  set background=dark
  let g:colors_name="dawn"
]])

local function hi(group)
  return function(opts)
    if opts then
      vim.api.nvim_set_hl(0, group, opts)
    end
  end
end

-- {{{ Color palette

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

hi "Conceal" {
  fg = Dawn.sapphire,
  bg = Dawn.none,
  bold = true,
}

hi "ColorColumn" {
  bg = Dawn.base,
}

hi "CursorColumn" {
  link = "ColorColumn",
}

hi "CursorLine" {
  link = "CursorColumn",
}

hi "Search" {
  fg = Dawn.crust,
  bg = Dawn.yellow,
}

hi "CurSearch" {
  link = "Search",
}

hi "IncSearch" {
  link = "Search",
}

hi "Substitute" {
  link = "Search",
}

hi "Cursor" {
  fg = Dawn.crust,
  bg = Dawn.text,
}

hi "lCursor" {
  link = "Cursor",
}

hi "CursorIM" {
  link = "Cursor",
}

hi "TermCursor" {
  link = "Cursor",
}

hi "TermCursorNC" {
  link = "TermCursor",
}

hi "DiagnosticOk"

hi "DiagnosticInfo" {
  fg = Dawn.teal,
}

hi "DiagnosticHint" {
  fg = Dawn.green,
}

hi "DiagnosticWarn" {
  fg = Dawn.yellow,
}

hi "DiagnosticError" {
  fg = Dawn.red,
}

hi "DiagnosticDeprecated" {
  fg = Dawn.surface0,
  italic = true,
}

hi "Directory" {
  fg = Dawn.blue,
  bold = true,
}

hi "DiffAdd" {
  fg = Dawn.green,
  bg = Dawn.none,
}

hi "DiffChange" {
  fg = Dawn.yellow,
  bg = Dawn.none,
}

hi "DiffDelete" {
  fg = Dawn.red,
  bg = Dawn.none,
}

hi "DiffText" {
  fg = Dawn.blue,
  bg = Dawn.none,
}

hi "EndOfBuffer" {
  fg = Dawn.slate,
  bg = Dawn.none,
}

hi "ErrorMsg" {
  fg = Dawn.red,
  bold = true,
}

hi "WinSeparator" {
  fg = Dawn.text,
  bg = Dawn.none,
}

hi "Folded" {
  fg = Dawn.slate,
  italic = true,
}

hi "FoldColumn"

hi "CursorLineFold" {
  link = "FoldColumn",
}

hi "SignColumn" {
  bg = Dawn.mantle,
}

hi "CursorLineSign" {
  link = "SignColumn",
}

hi "LineNr" {
  fg = Dawn.overlay0,
  bg = Dawn.none,
}

hi "LineNrAbove" {
  link = "LineNr",
}

hi "LineNrBelow" {
  link = "LineNr",
}

hi "CursorLineNr" {
  fg = Dawn.sky,
  bg = Dawn.none,
  bold = true,
}

hi "MatchParen" {
  fg = Dawn.peach,
  bg = Dawn.overlay0,
}

hi "ModeMsg" {
  fg = Dawn.mauve,
  bg = Dawn.none,
  italic = true,
}

hi "MsgArea" {
  link = "Normal",
}

hi "MsgSeparator"

hi "MoreMsg" {
  fg = Dawn.subtext1,
  bold = true,
}

hi "NonText" {
  fg = Dawn.surface2,
}

hi "Normal" {
  fg = Dawn.text,
  bg = Dawn.mantle,
}

hi "NormalNC" {
  link = "Normal",
}

hi "NormalFloat" {
  fg = Dawn.text,
  bg = Dawn.crust,
}

hi "FloatBorder" {
  fg = Dawn.lavender,
  bg = Dawn.crust,
}

hi "FloatShadow"
hi "FloatShadowThrough"

hi "FloatTitle" {
  fg = Dawn.blue,
  bg = Dawn.crust,
  bold = true,
}

hi "Pmenu" {
  fg = Dawn.surface2,
  bg = Dawn.base,
}

hi "PmenuSel" {
  fg = Dawn.text,
  bg = Dawn.surface0,
  bold = true,
}

hi "PmenuKind"
hi "PmenuKindSel"
hi "PmenuExtra"
hi "PmenuExtraSel"

hi "PmenuSbar" {
  bg = Dawn.crust,
}

hi "PmenuThumb" {
  bg = Dawn.surface0,
}

hi "Question" {
  fg = Dawn.green,
}

hi "QuickFixLine"

hi "SpecialKey" {
  fg = Dawn.mauve,
  italic = true,
}

hi "SpellBad" {
  fg = Dawn.red,
  bold = true,
}

hi "SpellCap"
hi "SpellLocal"
hi "SpellRare"

hi "StatusLine" {
  fg = Dawn.lavender,
  bg = Dawn.crust,
}

hi "StatusLineNC" {
  fg = Dawn.none,
  bg = Dawn.crust,
}

hi "TabLine" {
  fg = Dawn.surface0,
  bg = Dawn.crust,
}

hi "TabLineFill" {
  fg = Dawn.surface0,
  bg = Dawn.crust,
}

hi "TabLineSel" {
  fg = Dawn.lavender,
  bg = Dawn.mantle,
}

hi "Title" {
  fg = Dawn.green,
  bold = true,
}

hi "Visual" {
  bg = Dawn.surface1,
}

hi "VisualNOS" {
  link = "Visual",
}

hi "WarningMsg" {
  fg = Dawn.yellow,
  bold = true,
}

hi "Whitespace" {
  fg = Dawn.surface0,
}

hi "WildMenu"

hi "WinBar" {
  fg = Dawn.sapphire,
  italic = true,
}

hi "WinBarNC" {
  link = "WinBar",
}

-- }}}

-- {{{ Syntax

hi "Boolean" {
  fg = Dawn.red,
}

hi "Character" {
  fg = Dawn.teal,
}

hi "SpecialChar" {
  fg = Dawn.teal,
  italic = true,
}

hi "Comment" {
  fg = Dawn.slate,
  italic = true,
}

hi "SpecialComment" {
  link = "Comment",
}

hi "Conditional" {
  fg = Dawn.mauve,
}

hi "Constant" {
  fg = Dawn.peach,
  bold = true,
}

hi "Debug"

hi "Define" {
  fg = Dawn.pink,
}

hi "Delimiter" {
  fg = Dawn.subtext0,
}

hi "Error" {
  fg = Dawn.red,
  bold = true,
}

hi "Exception" {
  fg = Dawn.red,
  bold = true,
}

hi "Float" {
  link = "Number",
}

hi "Function" {
  fg = Dawn.blue,
}

hi "Identifier" {
  fg = Dawn.text,
}

hi "Ignore"

hi "Include" {
  fg = Dawn.mauve,
}

hi "Keyword" {
  fg = Dawn.mauve,
}

hi "Label" {
  fg = Dawn.sapphire,
}

hi "Macro" {
  fg = Dawn.mauve,
  italic = true,
}

hi "Number" {
  fg = Dawn.red,
}

hi "Operator" {
  fg = Dawn.yellow,
}

hi "PreCondit" {
  fg = Dawn.pink,
  bold = true,
}

hi "PreProc" {
  fg = Dawn.pink,
  bold = true,
}

hi "Repeat" {
  fg = Dawn.mauve,
}

hi "StorageClass" {
  fg = Dawn.sapphire,
}

hi "Structure" {
  link = "Type",
}

hi "Special" {
  fg = Dawn.mauve,
  bold = true,
}

hi "Statement"

hi "String" {
  fg = Dawn.green,
}

hi "Tag" {
  fg = Dawn.maroon,
}

hi "Todo" {
  fg = Dawn.yellow,
  bold = true,
}

hi "Type" {
  fg = Dawn.poggers,
  bold = true,
  italic = true,
}

hi "Typedef" {
  link = "Type",
}

hi "Underlined" {
  underline = true,
}

hi "Variable" {
  fg = Dawn.text,
}

-- }}}

-- {{{ Treesitter

hi "@attribute" {
  fg = Dawn.maroon,
}

hi "@constant.builtin" {
  link = "@constant",
}

hi "@constructor.lua" {
  link = "@punctuation.bracket.lua",
}

hi "@field" {
  fg = Dawn.lavender,
}

hi "@function.builtin" {
  fg = Dawn.peach,
  italic = true,
}

hi "@namespace" {
  fg = Dawn.blue,
}

hi "@tag.delimiter" {
  link = "Delimiter",
}

hi "@type.qualifier" {
  link = "@operator",
}

hi "@parameter" {
  fg = Dawn.maroon,
}

hi "@property" {
  link = "@attribute",
}

hi "@punctiation" {
  link = "Delimiter",
}

hi "@variable" {
  link = "Variable",
}

hi "@variable.builtin" {
  fg = Dawn.maroon,
}

-- }}}

-- {{{ Semantic Highlights

hi "@lsp.mod.attribute" {
  link = "@identifier",
}

hi "@lsp.mod.constant" {
  link = "@constant",
}

hi "@lsp.mod.controlFlow" {
  fg = Dawn.sapphire,
}

hi "@lsp.mod.crateRoot.rust" {
  fg = Dawn.pink,
  bold = true,
}

hi "@lsp.mod.library" {
  link = "@namespace",
}

hi "@lsp.type.boolean" {
  link = "@boolean",
}

hi "@lsp.type.builtinType" {
  link = "@type.builtin",
}

hi "@lsp.type.formatSpecifier" {
  link = "@punctiation",
}

hi "@lsp.type.keyword" {
  link = "@keyword",
}

hi "@lsp.type.namespace" {
  link = "@namespace",
}

hi "@lsp.type.number" {
  link = "@number",
}

hi "@lsp.type.operator" {
  link = "@operator",
}

hi "@lsp.type.parameter" {
  link = "@parameter",
}

hi "@lsp.type.property" {
  link = "@attribute",
}

hi "@lsp.type.punctuation" {
  link = "@punctuation",
}

hi "@lsp.type.selfKeyword" {
  fg = Dawn.red,
  bold = true,
}

hi "@lsp.type.selfTypeKeyword" {
  link = "@type",
}

hi "@lsp.type.typeAlias" {
  link = "@type",
}

hi "@lsp.type.variable" {
  link = "@variable",
}

hi "@lsp.typemod.attributeBracket" {
  link = "@punctuation",
}

hi "@lsp.typemod.decorator" {
  fg = Dawn.flamingo,
}

hi "@lsp.typemod.derive" {
  fg = Dawn.rosewater,
  italic = true,
}

hi "@lsp.typemod.enum" {
  link = "@type",
}

hi "@lsp.typemod.enumMember" {
  link = "@lsp.type.enumMember",
}

hi "@lsp.typemod.interface" {
  fg = Dawn.flamingo,
  bold = true,
  italic = true,
}

hi "@lsp.typemod.keyword.async" {
  link = "Keyword",
}

hi "@lsp.typemod.macro" {
  link = "@macro",
}

hi "@lsp.typemod.method" {
  link = "@function",
}

hi "@lsp.typemod.keyword.controlFlow" {
  link = "@conditional",
}

hi "@lsp.typemod.namespace" {
  link = "@namespace",
}

hi "@lsp.typemod.operator.attribute" {
  link = "@punctuation",
}

hi "@lsp.typemod.struct" {
  link = "@type",
}

hi "@lsp.typemod.typeAlias" {
  link = "@type",
}

hi "@lsp.typemod.variable.constant" {
  link = "@constant",
}

-- }}}

-- {{{ Telescope

hi "TelescopeBorder" {
  fg = Dawn.poggers,
  bg = Dawn.none,
}

hi "TelescopeNormal" {
  fg = Dawn.lavender,
  bg = Dawn.none,
}

hi "TelescopeSelection" {
  fg = Dawn.red,
  bg = Dawn.none,
}

hi "TelescopeSelectionCaret" {
  fg = Dawn.poggers,
  bg = Dawn.none,
}

-- }}}

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua fdm=marker fdl=0
