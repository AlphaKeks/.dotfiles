-- https://GitHub.com/AlphaKeks/.dotfiles

local layout = require("awful").layout

layout.layouts = {
  layout.suit.tile.left,
  layout.suit.fair,
  layout.suit.floating,
}

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
