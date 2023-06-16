-- https://GitHub.com/AlphaKeks/.dotfiles

local lir_installed, lir = pcall(require, "lir")

if not lir_installed then
  return
end

local actions = require "lir.actions"

lir.setup {
  show_hidden_files = true,
  hide_cursor = false,

  ignore = {},

  devicons = {
    enable = true,
    highlight_dirname = true,
  },

  float = {
    winblend = 20,
    curdir_window = {
      enable = true,
      highlight_dirname = false,
    },
  },

  mappings = {
    ["<CR>"] = actions.edit,
    ["<C-s>"] = actions.split,
    ["<C-v>"] = actions.vsplit,
    ["<C-t>"] = actions.tabedit,
    ["<BS>"] = actions.up,
    ["q"] = actions.quit,
    ["a"] = actions.newfile,
    ["r"] = actions.rename,
    ["y"] = actions.yank_path,
    ["."] = actions.toggle_show_hidden,
    ["d"] = actions.delete,
  },
}

nn("<Leader>e", function()
  local cwd = vim.fn.expand "%:h"
  return vim.print(":edit %:h<CR>")
end, { silent = true, expr = true })

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
