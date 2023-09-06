local term = require("wezterm")

return {
	default_prog = { "zsh" },
	color_scheme = "Catppuccin Mocha",
	colors = { background = "#11111B" },
	font = term.font({ family = "JetBrains Mono" }),
	font_size = 14,
	line_height = 1,
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = false,
	default_cursor_style = "BlinkingBlock",
	window_background_opacity = 1,
	cursor_blink_rate = 727,
	cursor_blink_ease_in = "Linear",
	cursor_blink_ease_out = "Linear",
	animation_fps = 1,
	scrollback_lines = 1000000,
	audible_bell = "Disabled",
	window_padding = {
		left = 4,
		right = 4,
		top = 4,
		bottom = 0
	},
	keys = {
		{
			key = "^",
			mods = "CTRL",
			action = term.action.SendKey({
				key = "^",
				mods = "CTRL",
			}),
		},
		{
			key = "Backspace",
			mods = "CTRL",
			action = term.action.SendKey({
				key = "w",
				mods = "CTRL",
			}),
		},
	},
}
