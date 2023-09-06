set rtp+=~/.vim
runtime! vimrc

set inccommand=split
set laststatus=3
set undodir=~/.local/state/nvim/undo
set pumblend=10
set winblend=10

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

colorscheme dawn

lua require("alphakeks")
