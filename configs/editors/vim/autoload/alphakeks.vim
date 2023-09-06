function! alphakeks#foldtext()
	let indentation = repeat(' ', indent(v:foldstart))
	let folded_lines = v:foldend - v:foldstart + 1
	return indentation . '/* ' . folded_lines . ' Lines folded */'
endfunction

function! alphakeks#statusline()
	let separator = '█'
	let filename = expand('%:p:.')
	let ruler = line('.') . ':' . col('.')

	return separator . ' ' . filename . '%=' . '%S    ' . ruler . ' ' . separator
endfunction

function! alphakeks#tabline()
	let string = ''

	for tab in range(tabpagenr('$'))
		if tab + 1 == tabpagenr()
			let string ..= '%#TabLineSel#'
		else
			let string ..= '%#TabLine#'
		endif

		let string ..= ' %{alphakeks#tablabel(' . (tab + 1) . ')} '
	endfor

	let string ..= '%#TabLineFill#%T'

	return string
endfunction

function! alphakeks#tablabel(idx)
	let buffers = tabpagebuflist(a:idx)
	let window_id = tabpagewinnr(a:idx)
	let buffer = buffers[window_id - 1]

	return bufname(buffer)
endfunction

function! alphakeks#save_and_exec()
	if &filetype == 'vim'
		silent! write
		source %
	endif
endfunction

" Alternative for `:cprev` and `:cnext`.
"
" This function will wrap around the start / end of the quickfix list.
function! alphakeks#qf_wrap(direction)
	if a:direction == 'prev'
		try
			cprev
		catch /^Vim\%((\a\+)\)\=:E553/
			clast
		endtry
	elseif a:direction == 'next'
		try
			cnext
		catch /^Vim\%((\a\+)\)\=:E553/
			cfirst
		endtry
	else
		echoerr 'Invalid direction! Must be "prev" or "next".'
	endif
endfunction

function! alphakeks#qf_delete_entry()
	let current = line('.')
	let qflist = getqflist()

	call remove(qflist, current - 1)
	call setqflist(qflist, 'r')
	execute ':' . current
endfunction

function! alphakeks#open_term()
	tabedit
	term
	wincmd o
	setlocal nonumber relativenumber scrolloff=0
	startinsert
endfunction
