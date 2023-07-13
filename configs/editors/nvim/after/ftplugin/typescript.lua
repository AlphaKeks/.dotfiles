source("~/.vim/after/ftplugin/typescript.vim")

local lsp = require("alphakeks.lsp.typescript")

vim.lsp.start(lsp.tsserver())

lsp.prettier()
lsp.eslint()
