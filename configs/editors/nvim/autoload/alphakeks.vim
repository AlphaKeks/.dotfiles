source ~/.vim/autoload/alphakeks.vim

function! alphakeks#save_and_exec()
	if &filetype == 'vim'
		silent! write
		source %
	elseif &filetype == 'lua'
		silent! write
		luafile %
	endif
endfunction
