-- https://GitHub.com/AlphaKeks/.dotfiles

local naughty = require("naughty")

local presets = naughty.config.presets
local errors = awesome.startup_errors

if errors then
	local errors = tostring(errors)

	naughty.notify({
		preset = presets.critical,
		title = "Errors occurred during startup.",
		text = errors,
	})
end

do
	local in_error = false

	awesome.connect_signal("debug::error", function(error)
		if in_error then
			return
		end

		in_error = true

		naughty.notify({
			preset = presets.critical,
			title = "ERROR",
			text = tostring(error),
		})

		in_error = false
	end)
end

