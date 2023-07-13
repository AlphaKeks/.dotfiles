source("~/.vim/after/ftplugin/rust.vim")

local config = require("alphakeks.lsp.rust")

vim.lsp.start(config)
