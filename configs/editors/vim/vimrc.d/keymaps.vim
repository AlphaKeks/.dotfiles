let g:mapleader = " "
map <Space> <Nop>

nnoremap <Leader>e :Explore<CR>
nnoremap <C-s> :write<CR>
nnoremap <silent> <ESC> :silent nohlsearch<CR>

" Save and execute current file
nnoremap <Leader>x :write <Bar> source <CR>

" Don't yank individual characters when deleting them
nnoremap x "_x

" Default `U` is stupid anyway
nnoremap U <C-r>

" Same with `Y`
nnoremap Y y$

" Clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>Y "+y$
vnoremap <Leader>Y "+y$
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>P "+P

" Move lines around
nnoremap <silent> J :m +1<CR>==
nnoremap <silent> K :m -2<CR>==
vnoremap <silent> J :m '>+1<CR>gv=gv
vnoremap <silent> K :m '<-2<CR>gv=gv

" Stay in visual mode when (in|de)denting
vnoremap < <gv
vnoremap > >gv

" Keep cursor at current position when yanking in visual mode
vnoremap y myy`y

" Window management
nnoremap <C-h> <CMD>wincmd h<CR>
nnoremap <C-j> <CMD>wincmd j<CR>
nnoremap <C-k> <CMD>wincmd k<CR>
nnoremap <C-l> <CMD>wincmd l<CR>
nnoremap <silent> <C-Up> <CMD>silent resize +1<CR>
nnoremap <silent> <C-Down> <CMD>silent resize -1<CR>
nnoremap <silent> <C-Right> <CMD>silent vertical resize +1<CR>
nnoremap <silent> <C-Left> <CMD>silent vertical resize -1<CR>

" Quickfix List
nnoremap <silent> <Leader>qo :silent copen<CR>
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>

" :terminal
tnoremap <C-]> <C-\><C-n>

" FZF
nnoremap <silent> <Leader>ff :FZF<CR>

" ripgrep
nnoremap <Leader>fl :grep 

" grep for word under cursor
nnoremap <Leader>fw :grep <C-r><C-w><CR>

" search the help
nnoremap <Leader>fh :helpgrep 

