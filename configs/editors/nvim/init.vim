" https://GitHub.com/AlphaKeks/.dotfiles

source ~/.vim/vimrc

set guicursor+=i:ver20
set laststatus=3
" set noshowmatch
set undodir=~/.config/nvim/undo
set pumblend=20
set winblend=20

colorscheme dawn

lua require "alphakeks"

" vim: et ts=2 sw=2 sts=2 ai si ft=vim
