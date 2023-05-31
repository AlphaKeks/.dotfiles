" https://GitHub.com/AlphaKeks/.dotfiles

setlocal noexpandtab

compiler cargo

nnoremap <Leader>rm :make clippy<CR>
nnoremap <Leader>rr :make run<CR>
nnoremap <Leader>rf mf:silent! %!rustfmt<CR>`f

" vim: et ts=2 sw=2 sts=2 ai si ft=vim
