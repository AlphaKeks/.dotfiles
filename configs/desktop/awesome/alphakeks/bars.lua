-- https://GitHub.com/AlphaKeks/.dotfiles

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function create_tags(screen)
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, screen, awful.layout.layouts[1])
end

local widgets = {}

widgets.menu = awful.menu({
	items = {
		{ "Restart", awesome.restart },
		{
			"👋",
			function()
				awesome.quit()
			end
		},
		{
			"Shutdown",
			function()
				os.execute("shutdown now")
			end,
		},
	},
})

widgets.launcher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = widgets.menu,
})

widgets.clock = wibox.widget({
	widget = wibox.widget.textclock,
	format = "  %H:%M %a %d/%m/%Y  ",
	refresh = 1,
})

widgets.separator = wibox.widget.separator()

widgets.systray = wibox.widget.systray()
widgets.systray:set_base_size(16)

awful.screen.connect_for_each_screen(function(screen)
	create_tags(screen)

	screen.taglist = awful.widget.taglist({
		screen = screen,
		filter = awful.widget.taglist.filter.all,
		buttons = gears.table.join(awful.button({}, 1, function(tag)
			tag:view_only()
		end)),
	})

	screen.wibar = awful.wibar({
		screen = screen,
		position = "bottom",
	})

	screen.wibar:setup({
		layout = wibox.layout.align.horizontal,
		{
			layout = wibox.layout.fixed.horizontal,
			widgets.launcher,
			screen.taglist,
		},

		widgets.separator,

		{
			layout = wibox.layout.fixed.horizontal,
			widgets.systray,
			widgets.clock,
		},
	})
end)
