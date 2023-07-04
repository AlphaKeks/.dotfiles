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
					},
				},
			},
		})
	end,
}
