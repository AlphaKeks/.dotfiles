-- https://GitHub.com/AlphaKeks/.dotfiles

vim.cmd.source("~/.vim/after/ftplugin/javascript.vim")

vim.lsp.start(require("alphakeks.lsp").configs.typescript())

