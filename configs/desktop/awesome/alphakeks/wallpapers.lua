-- https://GitHub.com/AlphaKeks/.dotfiles

local awful = require("awful")
local wibox = require("wibox")

-- TODO: add wallpapers
local wallpapers = {
	"/home/alphakeks/Pictures/Wallpapers/catppuccinxdawn2.png",
	"/home/alphakeks/Pictures/Wallpapers/hashtags-black.png",
	"/home/alphakeks/Pictures/Dawn/5623eabd-27e3-48d4-a7f9-1e7d17e226ab.png",
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
