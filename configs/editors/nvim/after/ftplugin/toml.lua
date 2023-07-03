-- https://GitHub.com/AlphaKeks/.dotfiles

local Lsp = require("alphakeks.lsp")

vim.lsp.start(require("alphakeks.lsp").configs.toml())

