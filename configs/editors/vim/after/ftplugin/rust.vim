setlocal noexpandtab
setlocal tabstop=8
setlocal shiftwidth=8
setlocal commentstring=//\ %s

compiler cargo

command! Clippy silent make clippy | redraw!
command! RustFormat silent make +nightly fmt | edit! | redraw!

augroup post_write_rust
	autocmd!
	autocmd BufWritePost *.rs execute 'RustFormat' | Clippy
augroup end
