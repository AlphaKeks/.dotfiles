-- https://GitHub.com/AlphaKeks/.dotfiles

source("~/.vim/after/ftplugin/typescript.vim")

local lsp = require("alphakeks.lsp").configs.typescript

vim.lsp.start(lsp.tsserver())

lsp.prettier()
lsp.eslint()
