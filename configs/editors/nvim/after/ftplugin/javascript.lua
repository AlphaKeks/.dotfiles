-- https://GitHub.com/AlphaKeks/.dotfiles

source("~/.vim/after/ftplugin/javascript.vim")

local config = require("alphakeks.lsp").configs.typescript

vim.lsp.start(config.tsserver())

config.prettier()
config.eslint()
