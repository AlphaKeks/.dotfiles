-- https://GitHub.com/AlphaKeks/.dotfiles

local programs = {
  ["picom"] = "picom -b --config " .. os.getenv("CONFIG") .. "/picom/picom.conf",
  ["flameshot"] = "flameshot",
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
