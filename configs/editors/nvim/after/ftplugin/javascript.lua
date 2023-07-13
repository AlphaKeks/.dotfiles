source("~/.vim/after/ftplugin/javascript.vim")

local lsp = require("alphakeks.lsp.typescript")

vim.lsp.start(lsp.tsserver())

lsp.prettier()
lsp.eslint()
