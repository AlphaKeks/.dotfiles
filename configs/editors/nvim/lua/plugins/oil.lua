return {
	"stevearc/oil.nvim",

	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local oil = require("oil")

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
				cursorcolumn = false,
				cursorline = true,
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

		vim.keymap.set("n", "<Leader>e", oil.open)
	end,
}
