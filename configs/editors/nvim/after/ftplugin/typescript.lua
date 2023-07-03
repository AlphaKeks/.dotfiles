-- https://GitHub.com/AlphaKeks/.dotfiles

vim.cmd.source("~/.vim/after/ftplugin/typescript.vim")

local lsp = require("alphakeks.lsp")

vim.lsp.start(lsp.configs.typescript())

