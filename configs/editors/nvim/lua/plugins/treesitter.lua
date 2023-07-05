return {
	"nvim-treesitter/nvim-treesitter",

	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects"
	},

	config = function()
		local ts = require("nvim-treesitter.configs")

		ts.setup({
			ensure_installed = {
				"vimdoc",
				"vim",
				"lua",
				"rust",
				"comment",
			},

			auto_install = true,

			highlight = {
				enable = true,
			},

			indent = {
				enable = true,
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-Space>",
					node_incremental = "<Leader>gn",
					node_decremental = "<Leader>gN",
					scope_incremental = "<Leader>gS",
				},
			},

			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["if"] = "@function.inner",
						["af"] = "@function.outer",
						["ic"] = "@class.inner",
						["ac"] = "@class.outer",
						["ia"] = "@parameter.inner",
						["aa"] = "@parameter.outer",
						["is"] = "@parameter.scope",
						["as"] = "@parameter.scope",
					},
				},
			},
		})
	end,
}
