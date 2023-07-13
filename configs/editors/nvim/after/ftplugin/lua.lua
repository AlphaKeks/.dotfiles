source("~/.vim/after/ftplugin/lua.vim")

local config = require("alphakeks.lsp.lua")

vim.lsp.start(config)
