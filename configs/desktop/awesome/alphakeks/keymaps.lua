-- https://GitHub.com/AlphaKeks/.dotfiles

local awful = require("awful")

awful.keyboard.append_global_keybindings({

	--[[ Awesome ]]--

	awful.key({ Keys.mod, Keys.shift }, "r", function()
		awesome.restart()
	end),

	--[[ Applications ]]--

	awful.key({ Keys.mod }, Keys.enter, function()
		awesome.spawn(Programs.terminal)
	end),

	awful.key({ Keys.mod }, Keys.space, function()
		awesome.spawn(Programs.launcher)
	end),

	awful.key({ Keys.mod }, "b", function()
		awesome.spawn(Programs.browser)
	end),

	awful.key({ Keys.mod }, "e", function()
		awesome.spawn(Programs.filemanager)
	end),

	awful.key({ }, Keys.print, function()
		awesome.spawn(Programs.screenshots)
	end),

	--[[ Window management ]]--

	awful.key({ Keys.mod }, "h", function()
		awful.client.focus.global_bydirection("left")
	end),

	awful.key({ Keys.mod }, "j", function()
		awful.client.focus.global_bydirection("down")
	end),

	awful.key({ Keys.mod }, "k", function()
		awful.client.focus.global_bydirection("up")
	end),

	awful.key({ Keys.mod }, "l", function()
		awful.client.focus.global_bydirection("right")
	end),

	awful.key({ Keys.mod, Keys.shift }, "h", function()
		awful.client.swap.global_bydirection("left")
	end),

	awful.key({ Keys.mod, Keys.shift }, "j", function()
		awful.client.swap.global_bydirection("down")
	end),

	awful.key({ Keys.mod, Keys.shift }, "k", function()
		awful.client.swap.global_bydirection("up")
	end),

	awful.key({ Keys.mod, Keys.shift }, "l", function()
		awful.client.swap.global_bydirection("right")
	end),
})

--[[ Workspaces ]]--
-- no I am NOT gonna call them "tags", fuck you.

for i = 1, 9 do
	awful.keyboard.append_global_keybindings({
		awful.key({ Keys.mod }, "#" .. i + 9, function()
			local tag = awful.screen.focused().tags[i]
			if tag then
				tag:view_only()
			end
		end),
	})
end

for i = 1, 9 do
	awful.keyboard.append_global_keybindings({
		awful.key({ Keys.mod, Keys.shift }, "#" .. i + 9, function()
			if not client.focus then
				return
			end

			local tag = client.focus.screen.tags[i]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end),
	})
end

client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings({
		awful.key({ Keys.mod }, "q", function(c)
			c:kill()
		end),

		awful.key({ Keys.mod }, "t", function(c)
			c.floating = false
			c:raise()
		end),

		awful.key({ Keys.mod }, "f", function(c)
			c.floating = true
			c:raise()
		end),

		awful.key({ Keys.mod, Keys.shift }, "f", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end),
	})
end)

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({ }, 1, function(c)
			c:activate({ context = "mouse_click" })
		end),

		awful.button({ Keys.mod }, 1, function(c)
			c:activate({
				context = "mouse_click",
				action = "mouse_move",
			})
		end),

		awful.button({ Keys.mod }, 3, function(c)
			c:activate({
				context = "mouse_click",
				action = "mouse_resize",
			})
		end),
	})
end)

