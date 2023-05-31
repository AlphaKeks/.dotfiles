-- https://GitHub.com/AlphaKeks/.dotfiles

local awful = require("awful")

local programs = {
  ["picom"] = "picom -b --config " .. os.getenv("HOME") .. "/.config/picom/picom.conf",
  ["flameshot"] = "flameshot",
  ["easyeffects"] = "easyeffects --gapplication-service",
  ["signal-desktop"] = "signal-desktop",
  ["discord"] = "discord",
  -- ["bitwarden"] = "bitwarden",
  -- ["steam"] = "steam",
}

for process, program in pairs(programs) do
  awful.spawn.with_shell(string.format(
    "pgrep -u $USER '%s' > /dev/null || (%s)",
    process, program
  ))
end

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
