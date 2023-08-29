" Name:          dawn.vim
" Author:        AlphaKeks <alphakeks@dawn.sh>
" Maintainer:    AlphaKeks <alphakeks@dawn.sh>
" Repository:    https://github.com/AlphaKeks/.dotfiles
" License:       MIT
"
" Color palette: https://github.com/catppuccin/nvim
"   rosewater -> "#F5E0DC"
"   flamingo  -> "#F2CDCD"
"   pink      -> "#F5C2E7"
"   mauve     -> "#CBA6F7"
"   red       -> "#F38BA8"
"   maroon    -> "#EBA0AC"
"   peach     -> "#FAB387"
"   yellow    -> "#F9E2AF"
"   green     -> "#A6E3A1"
"   teal      -> "#94E2D5"
"   sky       -> "#89DCEB"
"   sapphire  -> "#74C7EC"
"   blue      -> "#89B4FA"
"   lavender  -> "#B4BEFE"
"   text      -> "#CDD6F4"
"   subtext1  -> "#BAC2DE"
"   subtext0  -> "#A6ADC8"
"   overlay2  -> "#9399B2"
"   overlay1  -> "#7F849C"
"   overlay0  -> "#6C7086"
"   surface2  -> "#585B70"
"   surface1  -> "#45475A"
"   surface0  -> "#313244"
"   base      -> "#1E1E2E"
"   mantle    -> "#181825"
"   crust     -> "#11111B"
"   none      -> "NONE"
"
" These are my own (͡ ͡° ͜ つ ͡͡°)
"   slate     -> "#3C5E7F"
"   poggers   -> "#7480C2"

set background=dark
let g:colors_name="dawn"

" {{{ Useful abbreviations for this file

" abbreviate <buffer> rosewater #F5E0DC
" abbreviate <buffer> flamingo #F2CDCD
" abbreviate <buffer> pink #F5C2E7
" abbreviate <buffer> mauve #CBA6F7
" abbreviate <buffer> red #F38BA8
" abbreviate <buffer> maroon #EBA0AC
" abbreviate <buffer> peach #FAB387
" abbreviate <buffer> yellow #F9E2AF
" abbreviate <buffer> green #A6E3A1
" abbreviate <buffer> teal #94E2D5
" abbreviate <buffer> sky #89DCEB
" abbreviate <buffer> sapphire #74C7EC
" abbreviate <buffer> blue #89B4FA
" abbreviate <buffer> lavender #B4BEFE
" abbreviate <buffer> text #CDD6F4
" abbreviate <buffer> subtext1 #BAC2DE
" abbreviate <buffer> subtext0 #A6ADC8
" abbreviate <buffer> overlay2 #9399B2
" abbreviate <buffer> overlay1 #7F849C
" abbreviate <buffer> overlay0 #6C7086
" abbreviate <buffer> surface2 #585B70
" abbreviate <buffer> surface1 #45475A
" abbreviate <buffer> surface0 #313244
" abbreviate <buffer> base #1E1E2E
" abbreviate <buffer> mantle #181825
" abbreviate <buffer> crust #11111B
" abbreviate <buffer> none NONE
" abbreviate <buffer> slate #3C5E7F
" abbreviate <buffer> poggers #7480C2

" }}}

" {{{ Editor

hi! ColorColumn guibg=#1E1E2E
hi! Conceal guifg=#74C7EC guibg=NONE gui=bold
hi! Cursor guifg=#11111B guibg=#CDD6F4
hi! link lCursor Cursor
hi! link CursorColumn ColorColumn
hi! link CursorLine CursorColumn
hi! Directory guifg=#89B4FA
hi! DiffAdd guifg=#A6E3A1 guibg=NONE
hi! link diffAdded DiffAdd
hi! DiffChange guifg=#89B4FA guibg=NONE
hi! link diffChanged DiffChange
hi! DiffDelete guifg=#F38BA8 guibg=NONE
hi! link diffRemoved DiffDelete
hi! DiffText guifg=#89B4FA guibg=NONE
hi! EndOfBuffer guifg=#3C5E7F
hi! ErrorMsg guifg=#F38BA8 guibg=NONE
hi! VertSplit guifg=NONE guibg=#B4BEFE
hi! Folded guifg=#3C5E7F guibg=#181825 gui=italic
hi! FoldColumn guifg=#74C7EC guibg=#181825
hi! link SignColumn FoldColumn
hi! IncSearch guifg=#7480C2 guibg=#11111B
hi! LineNr guifg=#6C7086 guibg=NONE
hi! link LineNrAbove LineNr
hi! link LineNrBelow LineNr
hi! CursorLineNr guifg=#F9E2AF guibg=NONE gui=bold cterm=NONE
hi! CursorLineFold guifg=#74C7EC guibg=#181825
hi! CursorLineSign guifg=#74C7EC guibg=#181825
hi! MatchParen guifg=#FAB387 guibg=NONE
hi! ModeMsg guifg=#CBA6F7 guibg=NONE gui=italic
hi! link MoreMsg ModeMsg
hi! NonText guifg=#CDD6F4 guibg=NONE
hi! Normal guifg=#CDD6F4 guibg=#181825
hi! Pmenu guifg=#585B70 guibg=#1E1E2E
hi! PmenuSel guifg=#CDD6F4 guibg=#313244 gui=bold
hi! PmenuKind guifg=#7480C2 guibg=#1E1E2E
hi! PmenuKindSel guifg=#7480C2 guibg=#313244 gui=bold
hi! PmenuExtra guifg=#7480C2 guibg=#1E1E2E
hi! PmenuExtraSel guifg=#7480C2 guibg=#313244 gui=bold
hi! PmenuSbar guibg=#11111B
hi! PmenuThumb guibg=#313244
hi! Question guifg=#A6E3A1
hi! link QuickFixLine CursorLine
hi! Search guifg=#11111B guibg=#F9E2AF
hi! CurSearch guifg=#11111B guibg=#F38BA8
hi! SpecialKey guifg=#CBA6F7 gui=italic
hi! SpellBad guifg=#11111B guibg=#F38BA8 gui=italic
hi! link SpellCap SpellBad
hi! link SpellLocal SpellBad
hi! link SpellRare SpellBad
hi! StatusLine guifg=#11111B guibg=#B4BEFE
hi! StatusLineNC guifg=#181825 guibg=#CDD6F4
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC
hi! TabLine guifg=#313244 guibg=#11111B gui=NONE
hi! TabLineFill guifg=#181825 guibg=#11111B
hi! TabLineSel guifg=#B4BEFE guibg=#181825
hi! link Terminal Normal
hi! Title guifg=#A6E3A1 gui=bold
hi! Visual guibg=#45475A
hi! link VisualNOS Visual
hi! WarningMsg guifg=#FAB387 guibg=NONE
hi! WhiteSpace guifg=#313244 guibg=NONE
hi! link WildMenu PmenuSel

" }}}

" {{{ Syntax

hi! Boolean guifg=#F38BA8
hi! Character guifg=#94E2D5
hi! Comment guifg=#3C5E7F gui=italic
hi! Conditional guifg=#CBA6F7
hi! Constant guifg=#FAB387 gui=bold
hi! Define guifg=#F5C2E7
hi! Delimiter guifg=#A6ADC8
hi! Error guifg=#F38BA8 guibg=NONE gui=bold
hi! link Exception Error
hi! link Float Number
hi! Function guifg=#89B4FA
hi! Identifier guifg=#CDD6F4
hi! link Ignore Comment
hi! Include guifg=#CBA6F7
hi! Keyword guifg=#CBA6F7
hi! Label guifg=#74C7EC
hi! Macro guifg=#CBA6F7 gui=italic
hi! Number guifg=#F38BA8
hi! Operator guifg=#A6ADC8
hi! PreCondit guifg=#F5C2E7 gui=bold
hi! PreProc guifg=#F5C2E7 gui=bold
hi! Repeat guifg=#CBA6F7
hi! Special guifg=#CBA6F7 gui=bold
hi! SpecialChar guifg=#94E2D5
hi! SpecialComment guifg=#A6E3A1 gui=italic
hi! StorageClass guifg=#74C7EC
hi! String guifg=#A6E3A1
hi! link Structure Type
hi! Tag guifg=#EBA0AC
hi! Todo guifg=#F9E2AF guibg=NONE gui=bold
hi! Type guifg=#7480C2 gui=bold,italic
hi! link Typedef Type
hi! Underlined gui=underline

" }}}

" vim: foldmethod=marker foldlevel=0
