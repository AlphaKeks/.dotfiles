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

-- delete all the stuff in ~/tmp and friends
awful.spawn.with_shell("rm -rf " .. os.getenv("HOME") .. "/tmp/*")
awful.spawn.with_shell("rm -rf " .. os.getenv("HOME") .. "/tmp/.*")

awful.spawn.with_shell("echo 'fn main() {\n\tprintln!(\"Hello, world!\");\n}' > " ..
	os.getenv("HOME") .. "/Playground/Rust/balls/src/main.rs")

awful.spawn.with_shell("echo 'async function main() {\n\tconsole.log(\"Hello, world!\");\n}\n\nmain();' > " ..
	os.getenv("HOME") .. "/Playground/TypeScript/balls/src/main.ts")
