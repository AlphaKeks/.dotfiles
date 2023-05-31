-- https://GitHub.com/AlphaKeks/.dotfiles

local awful = require("awful")
local wibox = require("wibox")

-- TODO: add wallpapers
local wallpapers = {
  "/home/alphakeks/Pictures/Wallpapers/catppuccinxdawn2.png",
  "/home/alphakeks/Pictures/Wallpapers/hashtags-black.png",
  "/home/alphakeks/Pictures/Wallpapers/lofi_dawn_croptop_schnose.png",
  "/home/alphakeks/Pictures/Wallpapers/hashtags-black.png",
}

for screen, wallpaper in ipairs(wallpapers) do
  awful.wallpaper({
    screen = screen,
    widget = {
      widget = wibox.container.tile,
      {
        widget = wibox.widget.imagebox,
        image = wallpaper,
      },
    },
  })
end

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
