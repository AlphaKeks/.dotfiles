-- https://GitHub.com/AlphaKeks/.dotfiles

local oil_installed, oil = pcall(require, "oil")

if not oil_installed then
	return
end

oil.setup({
	columns = {
		"icon",
		"mtime",
	},

	buf_options = {
		buflisted = false,
		bufhidden = "hide",
	},

	win_options = {
		wrap = true,
		cursorcolumn = true,
		colorcolumn = "",
	},

	default_file_explorer = true,

	keymaps = {
		["g?"] = "actions.show_help",
		["<CR>"] = "actions.select",
		["<C-v>"] = "actions.select_vsplit",
		["<C-t>"] = "actions.select_tab",
		["<C-p>"] = "actions.preview",
		["<ESC>"] = "actions.close",
		["<C-l>"] = "actions.refresh",
		["<BS>"] = "actions.parent",
		["g."] = "actions.toggle_hidden",
	},

	use_default_keymaps = false,

	view_options = {
		show_hidden = true,
	},

	preview = {
		win_options = {
			winblend = 10,
		},
	},
})

nn("<Leader>e", oil.open)
