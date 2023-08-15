source("~/.vim/after/ftplugin/typescript.vim")

vim.bo.formatprg = nil

local typescript = require("typescript")

vim.lsp.start(typescript.tsserver())

typescript.prettier.setup()
typescript.eslint.setup()
