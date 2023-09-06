let g:colors_name = 'dawn'
set background=dark
highlight clear

function! s:highlight(group, attrs)
	let command = 'highlight! ' . a:group

	let term = get(a:attrs, 'term', 'NONE')
	let command ..= ' term=' . term

	let cterm = get(a:attrs, 'cterm', 'NONE')
	let command ..= ' cterm=' . cterm

	let ctermfg = get(a:attrs, 'ctermfg', 'NONE')
	let command ..= ' ctermfg=' . ctermfg

	let ctermbg = get(a:attrs, 'ctermbg', 'NONE')
	let command ..= ' ctermbg=' . ctermbg

	let gui = get(a:attrs, 'gui', 'NONE')
	let command ..= ' gui=' . gui

	let guifg = get(a:attrs, 'guifg', 'NONE')
	let command ..= ' guifg=' . guifg

	let guibg = get(a:attrs, 'guibg', 'NONE')
	let command ..= ' guibg=' . guibg

	let guisp = get(a:attrs, 'guisp', 'NONE')
	let command ..= ' guisp=' . guisp

	execute command
endfunction

function! s:link(group, link)
	execute 'highlight! link ' . a:group . ' ' . a:link
endfunction

" {{{
"
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
"
" }}}

call s:highlight('ColorColumn', { 'guibg': '#181825' })
call s:link('Conceal', 'ColorColumn')
call s:highlight('Directory', { 'guifg': '#74C7EC', 'gui': 'bold' })
call s:highlight('EndOfBuffer', { 'guifg': '#313244' })
call s:highlight('ErrorMsg', { 'guifg': '#F38BA8' })
call s:highlight('Ignore', { 'guifg': '#3C5E7F', 'guibg': '#181825' })
call s:highlight('MatchParen', { 'guifg': '#FAB387', 'gui': 'bold' })
call s:highlight('ModeMsg', { 'guifg': '#CBA6F7', 'gui': 'italic'})
call s:highlight('MoreMsg', { 'guifg': '#FAB387', 'gui': 'bold'})
call s:highlight('NonText', { 'guifg': '#3C5E7F', 'guibg': '#11111B' })
call s:highlight('Normal', { 'guifg': '#CDD6F4', 'guibg': '#11111B' })
call s:link('Question', 'MoreMsg')
call s:highlight('SpecialKey', { 'guifg': '#313244' })
call s:highlight('Title', { 'guifg': '#7480C2' })
call s:highlight('VertSplit', { 'guifg': '#CDD6F4', 'guibg': 'NONE' })
call s:highlight('Visual', { 'guifg': '#11111B', 'guibg': '#7480C2' })
call s:link('VisualNOS', 'Visual')
call s:highlight('WarningMsg', { 'guifg': '#FAB387' })

" search
call s:highlight('Search', { 'guifg': '#11111B', 'guibg': '#F9E2AF' })
call s:highlight('CurSearch', { 'guifg': '#11111B', 'guibg': '#F38BA8' })
call s:highlight('IncSearch', { 'guifg': '#11111B', 'guibg': '#7480C2' })

" cursor
call s:highlight('Cursor', { 'guifg': '#11111B', 'guibg': '#FFFFFF' })
call s:link('lCursor', 'Cursor')
call s:highlight('CursorColumn', { 'guibg': '#181825' })
call s:link('CursorLine', 'CursorColumn')
call s:link('CursorLineFold', 'CursorLine')
call s:link('CursorLineSign', 'CursorLine')

" statuscolumn
call s:highlight('LineNr', { 'guifg': '#585B70' })
call s:highlight('CursorLineNr', { 'guifg': '#F9E2AF', 'guibg': '#181825' })
call s:link('SignColumn', 'LineNr')

" statusline
call s:highlight('StatusLine', { 'guifg': '#A6ADC8', 'guibg': '#11111B' })
call s:highlight('StatusLineNC', { 'guifg': '#313244', 'guibg': '#181825' })
call s:link('StatusLineTerm', 'StatusLine')
call s:link('StatusLineTermNC', 'StatusLineNC')

" tabline
call s:highlight('TabLine', { 'guifg': '#585B70', 'guibg': '#1E1E2E' })
call s:highlight('TabLineFill', { 'guifg': '#11111B', 'guibg': '#11111B' })
call s:highlight('TabLineSel', { 'guifg': '#CDD6F4', 'guibg': '#181825' })

" diffs
call s:highlight('DiffAdd', { 'guifg': '#A6E3A1' })
call s:highlight('DiffChange', { 'guifg': '#89B4FA' })
call s:highlight('DiffDelete', { 'guifg': '#F38BA8' })
call s:link('DiffText', 'Normal')

" folds
call s:highlight('Folded', { 'guifg': '#3C5E7F', 'gui': 'italic' })
call s:link('FoldColumn', 'LineNr')

" completion
call s:highlight('Pmenu', { 'guifg': '#585B70', 'guibg': '#1E1E2E' })
call s:highlight('PmenuSel', { 'guifg': '#CDD6F4', 'guibg': '#181825' })
call s:highlight('PmenuExtra', { 'guifg': '#313244', 'guibg': '#1E1E2E' })
call s:highlight('PmenuSbar', { 'guibg': '#313244' })
call s:highlight('PmenuThumb', { 'guibg': '#585B70' })
call s:link('PmenuExtraSel', 'PmenuSel')
call s:link('PmenuKind', 'PmenuExtra')
call s:link('PmenuKindSel', 'PmenuKind')
call s:link('WildMenu', 'PmenuSel')

" qflist
call s:highlight('QuickFixLine', { 'guifg': 'yellow', 'guibg': '#181825' })

" spell
call s:highlight('SpellBad', { 'guifg': '#F38BA8' })
call s:highlight('SpellCap', { 'guifg': '#FAB387' })
call s:link('SpellLocal', 'SpellCap')
call s:link('SpellRare', 'SpellCap')

" syntax
call s:highlight('Boolean', { 'guifg': '#F38BA8' })
call s:highlight('Character', { 'guifg': '#94E2D5' })
call s:highlight('Comment', { 'guifg': '#3C5E7F', 'gui': 'italic' })
call s:highlight('Conditional', { 'guifg': '#CBA6F7' })
call s:highlight('Constant', { 'guifg': '#FAB387', 'gui': 'bold' })
call s:highlight('Debug', { 'guifg': '#F38BA8', 'gui': 'italic' })
call s:highlight('Define', { 'guifg': '#F5C2E7' })
call s:highlight('Delimiter', { 'guifg': '#7F849C' })
call s:highlight('Error', { 'guifg': '#F38BA8', 'gui': 'bold,italic' })
call s:link('Exception', 'Error')
call s:highlight('Number', { 'guifg': '#F38BA8' })
call s:link('Float', 'Number')
call s:highlight('Function', { 'guifg': '#89B4FA' })
call s:highlight('Identifier', { 'guifg': '#CDD6F4' })
call s:highlight('Include', { 'guifg': '#CBA6F7' })
call s:highlight('Macro', { 'guifg': '#89DCEB' })
call s:link('Operator', 'Delimiter')
call s:link('PreCondit', 'Macro')
call s:link('PreProc', 'Macro')
call s:highlight('Repeat', { 'guifg': '#CBA6F7' })
call s:highlight('Special', { 'guifg': '#74C7EC' })
call s:link('SpecialChar', 'Special')
call s:link('SpecialComment', 'Special')
call s:highlight('Statement', { 'guifg': '#CBA6F7' })
call s:highlight('StorageClass', { 'guifg': '#74C7EC' })
call s:highlight('String', { 'guifg': '#A6E3A1' })
call s:highlight('Todo', { 'guifg': '#F9E2AF', 'gui': 'bold' })
call s:highlight('Type', { 'guifg': '#7480C2', 'gui': 'bold,italic' })
call s:link('Typedef', 'Type')
call s:link('Structure', 'Type')
call s:highlight('Underlined', { 'gui': 'underline' })

" vim: foldmethod=marker foldlevel=0
