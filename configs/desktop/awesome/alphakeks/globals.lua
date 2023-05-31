-- https://GitHub.com/AlphaKeks/.dotfiles

awful = require("awful")
naughty = require("naughty")
gears = require("gears")
wibox = require("wibox")
beautiful = require("beautiful")
ruled = require("ruled")

function try(command, title)
  awful.spawn.easy_async(command, function(stdout, stderr, reason, code)
    if code ~= 0 then
      naughty.notify({
        preset = presets.critical,
        title = title or "command failed",
        text = reason,
      })
    end
  end)
end

Programs = {
  editor = os.getenv("EDITOR") or "vim",
  terminal = os.getenv("TERMINAL") or "wezterm",
  browser = os.getenv("BROWSER") or "firefox",
  filemanager = "thunar",
  launcher = "rofi -show drun",
  screenshots = "flameshot gui",
}

Keys = {
  mod = "Mod4",
  shift = "Shift",
  ctrl = "Control",
  space = "space",
  enter = "Return",
  print = "Print",
}

Colors = {
  rosewater = "#F5E0DC",
  flamingo = "#F2CDCD",
  pink = "#F5C2E7",
  mauve = "#CBA6F7",
  red = "#F38BA8",
  maroon = "#EBA0AC",
  peach = "#FAB387",
  yellow = "#F9E2AF",
  green = "#A6E3A1",
  teal = "#94E2D5",
  sky = "#89DCEB",
  sapphire = "#74C7EC",
  blue = "#89B4FA",
  lavender = "#B4BEFE",
  text = "#CDD6F4",
  subtext1 = "#BAC2DE",
  subtext0 = "#A6ADC8",
  overlay2 = "#9399B2",
  overlay1 = "#7F849C",
  overlay0 = "#6C7086",
  surface2 = "#585B70",
  surface1 = "#45475A",
  surface0 = "#313244",
  base = "#1E1E2E",
  mantle = "#181825",
  crust = "#11111B",

  poggers = "#7480C2",
}

Fonts = {
  normal = "Quicksand 12",
  monospace = "JetBrains Mono",
}

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
