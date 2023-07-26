lua require("globals")

source ~/.vim/vimrc.d/options.vim
source ~/.vim/vimrc.d/keymaps.vim

set inccommand=split
set laststatus=3
set mouse=
set pumblend=10
set undodir=~/.config/nvim/undo
set winblend=10

colorscheme dawn
au TextYankPost * lua vim.highlight.on_yank({ timeout = 250 })

lua require("alphakeks")
