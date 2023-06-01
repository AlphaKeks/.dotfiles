-- https://GitHub.com/AlphaKeks/.dotfiles

local commands = {
  "xrandr --output DisplayPort-0 --mode 1920x1080 --rate 240.30 --primary --dpi 96",
  "xrandr --output DisplayPort-1 --mode 1920x1080 --rate 60.00 --dpi 96 --left-of DisplayPort-0",
  "xrandr --output DisplayPort-2 --mode 1920x1080 --rate 60.00 --dpi 96 --above DisplayPort-0",
  "xrandr --output HDMI-A-2 --mode 1920x1080 --rate 60.00 --dpi 96 --right-of DisplayPort-0",
  "xrdb -merge $HOME/.Xresources",
}

for _, command in ipairs(commands) do
  os.execute(command)
end

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
