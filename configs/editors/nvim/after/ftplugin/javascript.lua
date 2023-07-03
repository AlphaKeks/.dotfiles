-- https://GitHub.com/AlphaKeks/.dotfiles

vim.cmd.source("~/.vim/after/ftplugin/javascript.vim")

local lsp = require("alphakeks.lsp")

vim.lsp.start(lsp.configs.typescript())

