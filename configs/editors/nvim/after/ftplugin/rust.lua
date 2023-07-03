-- https://GitHub.com/AlphaKeks/.dotfiles

vim.cmd.source("~/.vim/after/ftplugin/rust.vim")

vim.lsp.start(require("alphakeks.lsp").configs.rust())

