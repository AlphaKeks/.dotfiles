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

-- delete all the stuff in ~/tmp
awful.spawn.with_shell("rm -rf " .. os.getenv("HOME") .. "/tmp/*")
awful.spawn.with_shell("rm -rf " .. os.getenv("HOME") .. "/tmp/.*")

