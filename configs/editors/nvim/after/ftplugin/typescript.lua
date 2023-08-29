source("~/.vim/after/ftplugin/typescript.vim")

local typescript = require("alphakeks.typescript")

vim.lsp.start(typescript.tsserver())

typescript.prettier.setup()
-- typescript.eslint.setup()
