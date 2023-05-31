-- https://GitHub.com/AlphaKeks/.dotfiles

-- luarocks if available
pcall(require, "luarocks.loader")

-- global variables
require("alphakeks.globals")

-- error notifications
require("alphakeks.errors")

-- Xrandr
require("alphakeks.xrandr")

-- keymaps
require("alphakeks.keymaps")

-- layouts
require("alphakeks.layouts")

-- window rules
require("alphakeks.rules")

-- theme (catppuccin (the best))
require("alphakeks.theme")

-- wallpapers
require("alphakeks.wallpapers")

-- status bars
require("alphakeks.bars")

-- notifications
require("alphakeks.notifications")

-- autostart applications
require("alphakeks.autostart")

-- fancy ass titlebars
local nice = require("plugins.nice")
nice({
  titlebar_color = Colors.crust,
  titlebar_height = 24,
  button_size = 14,
  mb_resize = nice.MB_MIDDLE,
  mb_contextmenu = nice.MB_RIGHT,
  titlebar_items = {
    left = {},
    middle = "title",
    right = { "maximize", "close" },
  },
  maximize_color = Colors.green,
  close_color = Colors.red,
})

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
