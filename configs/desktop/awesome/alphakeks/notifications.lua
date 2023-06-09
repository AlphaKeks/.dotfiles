-- https://GitHub.com/AlphaKeks/.dotfiles

local awful = require("awful")
local naughty = require("naughty")
local ruled = require("ruled")

ruled.notification.connect_signal("request::rules", function()
	ruled.notification.append_rule({
		rule = {},
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 5,
		},
	})
end)

naughty.connect_signal("request::display", function(notification)
	naughty.layout.box({ notification = notification })
end)

