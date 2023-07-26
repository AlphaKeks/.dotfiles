-- https://GitHub.com/AlphaKeks/.dotfiles

local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

beautiful.init({
	-- The Awesome icon path
	-- awesome_icon = "",
	-- The default focused element background color
	bg_focus = Colors.base,
	-- The default minimized element background color
	bg_minimize = Colors.mantle,
	-- The default background color
	bg_normal = Colors.base,
	-- The systray background color
	bg_systray = Colors.base,
	-- The default urgent element background color
	bg_urgent = Colors.red,
	-- The border color when the client is active
	border_color_active = Colors.base,
	-- The fallback border color when the client is floating
	border_color_floating = Colors.subtext1,
	-- The border color when the (floating) client is active
	border_color_floating_active = Colors.text,
	-- The border color when the (floating) client is not active and new
	border_color_floating_new = Colors.subtext1,
	-- The border color when the (floating) client is not active
	border_color_floating_normal = Colors.subtext1,
	-- The border color when the (floating) client has the urgent property set
	border_color_floating_urgent = Colors.red,
	-- The border color when the (fullscreen) client has the urgent property set
	border_color_fullscreen_urgent = Colors.red,
	-- The border color when the client is marked
	border_color_marked = Colors.mauve,
	-- The border color when the client is not active and new
	border_color_new = Colors.base,
	-- The border color when the client is not active
	border_color_normal = Colors.base,
	-- The border color when the client has the urgent property set
	border_color_urgent = Colors.red,
	-- The fallback border width when nothing else is set
	border_width = 0,
	-- The client border width for the active client
	border_width_active = 0,
	-- The fallback border width when the client is floating
	border_width_floating = 2,
	-- The client border width for the active floating client
	border_width_floating_active = 2,
	-- The client border width for the new floating clients
	border_width_floating_new = 2,
	-- The client border width for the normal floating clients
	border_width_floating_normal = 2,
	-- The client border width for the urgent floating clients
	border_width_floating_urgent = 2,
	-- The client border width for the fullscreen clients
	border_width_fullscreen = 0,
	-- The client border width for the active fullscreen client
	border_width_fullscreen_active = 0,
	-- The client border width for the new fullscreen clients
	border_width_fullscreen_new = 0,
	-- The client border width for the normal fullscreen clients
	border_width_fullscreen_normal = 0,
	-- The client border width for the urgent fullscreen clients
	border_width_fullscreen_urgent = 2,
	-- The fallback border width when the client is maximized
	border_width_maximized = 0,
	-- The client border width for the active maximized client
	border_width_maximized_active = 0,
	-- The client border width for the new maximized clients
	border_width_maximized_new = 0,
	-- The client border width for the normal maximized clients
	border_width_maximized_normal = 0,
	-- The client border width for the urgent maximized clients
	border_width_maximized_urgent = 2,
	-- The client border width for the new clients
	border_width_new = 0,
	-- The client border width for the normal clients
	border_width_normal = 0,
	-- The client border width for the urgent clients
	border_width_urgent = 0,
	-- The calendar font
	calendar_font = Fonts.normal,
	-- Format the weekdays with three characters instead of two
	calendar_long_weekdays = true,
	-- Start the week on Sunday
	calendar_start_sunday = false,
	-- Display the calendar week numbers
	calendar_week_numbers = false,
	-- The outer (unchecked area) background color, pattern or gradient
	checkbox_bg = Colors.mantle,
	-- The outer (unchecked area) border color
	checkbox_border_color = Colors.crust,
	-- The outer (unchecked area) border width
	checkbox_border_width = 1,
	-- The checked part border color
	checkbox_check_border_color = Colors.lavender,
	-- The checked part border width
	checkbox_check_border_width = 2,
	-- The checked part filling color
	checkbox_check_color = Colors.subtext0,
	-- The checked part shape
	checkbox_check_shape = "rectangle",
	-- The padding between the outline and the progressbar
	checkbox_paddings = 2,
	-- The outer (unchecked area) shape
	checkbox_shape = "rectangle",
	-- The default focused element foreground (text) color
	fg_focus = Colors.text,
	-- The default minimized element foreground (text) color
	fg_minimize = Colors.text,
	-- The default focused element foreground (text) color
	fg_normal = Colors.text,
	-- The default urgent element foreground (text) color
	fg_urgent = Colors.red,
	-- The default font
	font = Fonts.normal,
	-- Hide the border on fullscreen clients
	fullscreen_hide_border = true,
	-- The graph foreground color
	graph_fg = Colors.poggers,
	-- The icon theme name
	icon_theme = "Papirus-Colors-Dark",
	-- The layoutlist font
	layoutlist_font = Fonts.monospace,
	-- The selected layout title font
	layoutlist_font_selected = Fonts.monospace,
	-- The default number of master windows
	master_count = 1,
	-- Hide the border on maximized clients
	maximized_hide_border = true,
	-- Honor the screen padding when maximizing
	maximized_honor_padding = false,
	-- The default focused item background color
	menu_bg_focus = Colors.base,
	-- The default background color
	menu_bg_normal = Colors.base,
	-- The menu item border color
	menu_border_color = Colors.base,
	-- The menu item border width
	menu_border_width = 1,
	-- The default focused item foreground (text) color
	menu_fg_focus = Colors.text,
	-- The default foreground (text) color
	menu_fg_normal = Colors.text,
	-- The menu text font
	menu_font = Fonts.normal,
	-- Menubar selected item background color
	menubar_bg_focus = Colors.overlay0,
	-- Menubar normal background color
	menubar_bg_normal = Colors.base,
	-- Menubar border color
	menubar_border_color = Colors.base,
	-- Menubar selected item text color
	menubar_fg_focus = Colors.text,
	-- Menubar normal text color
	menubar_fg_normal = Colors.text,
	-- Menubar font
	menubar_font = Fonts.normal,
	-- The background color for normal actions
	notification_action_bg_normal = Colors.base,
	-- The background color for selected actions
	notification_action_bg_selected = Colors.overlay0,
	-- The background image for normal actions
	notification_action_bgimage_normal = Colors.mantle,
	-- The background image for selected actions
	notification_action_bgimage_selected = Colors.overlay0,
	-- The foreground color for normal actions
	notification_action_fg_normal = Colors.text,
	-- The foreground color for selected actions
	notification_action_fg_selected = Colors.lavender,
	-- Notifications background color
	notification_bg = Colors.crust,
	-- The background color for normal notifications
	notification_bg_normal = Colors.crust,
	-- The background color for selected notifications
	notification_bg_selected = Colors.surface2,
	-- Notifications border color
	notification_border_color = Colors.poggers,
	-- Notifications border width
	notification_border_width = 2,
	-- The foreground color for normal notifications
	notification_fg_normal = Colors.overlay0,
	-- The foreground color for selected notifications
	notification_fg_selected = Colors.overlay2,
	-- Notifications font
	notification_font = Fonts.normal,
	-- The maximum notification position
	notification_position = "bottom_right",
	-- The client opacity for the normal clients
	opacity_normal = 1,
	-- The client opacity for the normal floating clients
	opacity_floating_normal = 0.95,
	-- The progressbar background color
	progressbar_bg = Colors.mantle,
	-- The progressbar foreground color
	progressbar_fg = Colors.poggers,
	-- The prompt background color
	prompt_bg = Colors.mantle,
	-- The prompt cursor background color
	prompt_bg_cursor = Colors.text,
	-- The prompt foreground color
	prompt_fg = Colors.text,
	-- The prompt cursor foreground color
	prompt_fg_cursor = Colors.text,
	-- The prompt text font
	prompt_font = Fonts.monspace,
	-- The separator's color
	separator_color = Colors.mantle,
	-- The systray icon spacing
	systray_icon_spacing = 12,
	-- The maximum number of rows for systray icons
	systray_max_rows = 1,
	-- The tag list empty elements background color
	taglist_bg_empty = Colors.mantle,
	-- The tag list main background color
	taglist_bg_focus = Colors.mantle,
	-- The tag list occupied elements background color
	taglist_bg_occupied = Colors.mantle,
	-- The tag list urgent elements background color
	taglist_bg_urgent = Colors.mantle,
	-- The tag list volatile elements background color
	taglist_bg_volatile = Colors.mantle,
	-- Do not display the tag icons, even if they are set
	taglist_disable_icon = true,
	-- The tag list empty elements foreground (text) color
	taglist_fg_empty = Colors.mantle,
	-- The tag list main foreground (text) color
	taglist_fg_focus = Colors.lavender,
	-- The tag list occupied elements foreground (text) color
	taglist_fg_occupied = Colors.surface1,
	-- The tag list urgent elements foreground (text) color
	taglist_fg_urgent = Colors.red,
	-- The tag list volatile elements foreground (text) color
	taglist_fg_volatile = Colors.yellow,
	-- The taglist font
	taglist_font = Fonts.monospace,
	-- The elements shape border color
	taglist_shape_border_color = Colors.mantle,
	-- The empty elements shape border color
	taglist_shape_border_color_empty = Colors.mantle,
	-- The selected elements shape border color
	taglist_shape_border_color_focus = Colors.mantle,
	-- The urgents elements shape border color
	taglist_shape_border_color_urgent = Colors.mantle,
	-- The volatile elements shape border color
	taglist_shape_border_color_volatile = Colors.mantle,
	-- The shape elements border width
	taglist_shape_border_width = 0,
	-- The shape used for the empty elements border width
	taglist_shape_border_width_empty = 0,
	-- The shape used for the selected elements border width
	taglist_shape_border_width_focus = 0,
	-- The shape used for the urgent elements border width
	taglist_shape_border_width_urgent = 0,
	-- The shape used for the volatile elements border width
	taglist_shape_border_width_volatile = 0,
	-- The space between the taglist elements
	taglist_spacing = dpi(1),
	-- The focused client background color
	tasklist_bg_focus = Colors.mantle,
	-- The minimized clients background color
	tasklist_bg_minimize = Colors.surface0,
	-- The default background color
	tasklist_bg_normal = Colors.mantle,
	-- The urgent clients background color
	tasklist_bg_urgent = Colors.red,
	-- Disable the tasklist client icons
	tasklist_disable_icon = Colors.red,
	-- Disable the tasklist client titles
	tasklist_disable_task_name = false,
	-- The focused client foreground (text) color
	tasklist_fg_focus = Colors.text,
	-- The minimized clients foreground (text) color
	tasklist_fg_minimize = Colors.text,
	-- The default foreground (text) color
	tasklist_fg_normal = Colors.text,
	-- The urgent clients foreground (text) color
	tasklist_fg_urgent = Colors.text,
	-- The tasklist font
	tasklist_font = Colors.normal,
	-- The focused client title alignment
	tasklist_font_focus = Colors.normal,
	-- The minimized clients font
	tasklist_font_minimized = Colors.normal,
	-- The urgent clients font
	tasklist_font_urgent = Colors.normal,
	-- The titlebar background color
	titlebar_bg = Colors.base,
	-- The focused titlebar background color
	titlebar_bg_focus = Colors.base,
	-- The titlebar background color
	titlebar_bg_normal = Colors.base,
	-- The urgent titlebar background color
	titlebar_bg_urgent = Colors.base,
	-- The titlebar foreground (text) color
	titlebar_fg = Colors.text,
	-- The focused titlebar foreground (text) color
	titlebar_fg_focus = Colors.text,
	-- The titlebar foreground (text) color
	titlebar_fg_normal = Colors.text,
	-- The urgent titlebar foreground (text) color
	titlebar_fg_urgent = Colors.red,
	-- The default gap
	useless_gap = dpi(0), -- 8
	-- The default wallpaper background color
	wallpaper_bg = Colors.base,
	-- The default wallpaper foreground color
	wallpaper_fg = Colors.base,
	-- The wibar's background color
	wibar_bg = Colors.mantle,
	-- The wibar border color
	wibar_border_color = Colors.mantle,
	-- The wibar border width
	wibar_border_width = 0,
	-- The wibar's foreground (text) color
	wibar_fg = Colors.text,
	-- The wibar's height
	wibar_height = 20,
	-- If the wibar is to be on top of other windows
	wibar_ontop = false,
})
