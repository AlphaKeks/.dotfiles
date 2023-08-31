lua require("alphakeks.globals")

source ~/.vim/vimrc.d/options.vim
source ~/.vim/vimrc.d/keymaps.vim

set completeopt-=preview
set inccommand=split
set laststatus=3
" set listchars=tab:\ \ ,trail:-
" let &statuscolumn=' %s %{v:relnum? v:relnum : v:lnum}' . repeat(' ', 15)
set mouse=
set pumblend=10
set undodir=~/.config/nvim/undo
set winblend=10

colorscheme dawn
au TextYankPost * lua vim.highlight.on_yank({ timeout = 69 })

lua require("alphakeks")
