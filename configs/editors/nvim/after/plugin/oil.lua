local oil_installed, oil = pcall(require, "oil")

if not oil_installed then
	return
end

oil.setup({
	default_file_explorer = true,
	columns = { "size" },
	win_options = {
		wrap = true,
		number = false,
		relativenumber = true,
	},
	keymaps = {
		["g?"] = "actions.show_help",
		["gh"] = "actions.toggle_hidden",
		["q"] = "actions.close",
		["<CR>"] = "actions.select",
		["<bs>"] = "actions.parent",
		["<C-v>"] = "actions.select_vsplit",
	},
	use_default_keymaps = false,
	view_options = {
		show_hidden = true,
	},
})

keymap("n", "<Leader>e", oil.open)
