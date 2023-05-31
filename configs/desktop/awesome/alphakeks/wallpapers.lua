-- https://GitHub.com/AlphaKeks/.dotfiles

-- TODO: add wallpapers
local wallpapers = {}

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
