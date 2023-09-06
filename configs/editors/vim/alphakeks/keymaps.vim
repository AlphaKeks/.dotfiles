let g:mapleader = ' '

map <Space> <NOP>

" files
nnoremap <Leader>e <cmd>Explore<CR>
nnoremap <C-s> :write<CR>

" the defaults for these are silly
nnoremap x "_x
nnoremap U <C-r>
nnoremap Y y$

" clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>Y "+y$
vnoremap <Leader>Y "+y$
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>P "+P

" clear search highlights
nnoremap <Esc> :nohlsearch<CR>

" keep cursor position when yanking in visual mode
vnoremap y myy`y

" stay in visual mode when [in|de]denting lines
vnoremap < <gv
vnoremap > >gv

" moving lines around
nnoremap <silent> J :m +1<CR>==
nnoremap <silent> K :m -2<CR>==
vnoremap <silent> J :m '>+1<CR>gv=gv
vnoremap <silent> K :m '<-2<CR>gv=gv

" qflist
nnoremap <Leader>qo :copen<CR>
nnoremap [q :call alphakeks#qf_wrap('prev')<CR>
nnoremap ]q :call alphakeks#qf_wrap('next')<CR>

" window management
nnoremap <C-h> <cmd>wincmd h<CR>
nnoremap <C-j> <cmd>wincmd j<CR>
nnoremap <C-k> <cmd>wincmd k<CR>
nnoremap <C-l> <cmd>wincmd l<CR>
nnoremap <C-Up> <cmd>resize +1<CR>
nnoremap <C-Down> <cmd>resize -1<CR>
nnoremap <C-Right> <cmd>vertical resize +1<CR>
nnoremap <C-Left> <cmd>vertical resize -1<CR>

" terminal
tnoremap <C-]> <C-\><C-n>
tnoremap <S-Space> <Space>
tnoremap <S-BS> <BS>

" search
nnoremap <Leader>ff <cmd>FZF<CR>
nnoremap <Leader>fl :Grep 
nnoremap <Leader>fw :Grep <C-r><C-w><CR>
nnoremap <Leader>fht :help *
nnoremap <Leader>fhh :helpgrep 

" save and source current file
nnoremap <Leader>x :call alphakeks#save_and_exec()<CR>

" expand filepaths in command mode
cnoremap %H <C-r>=expand('%:p:h')<CR>
cnoremap %T <C-r>=expand('%:t')<CR>
