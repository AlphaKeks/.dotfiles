source("~/.vim/after/ftplugin/javascript.vim")

local typescript = require("alphakeks.typescript")

vim.lsp.start(typescript.tsserver())

typescript.prettier.setup()
typescript.eslint.setup()
