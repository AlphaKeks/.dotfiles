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
					node_incremental = "<C-Space>",
					scope_incremental = "gs",
				},
			},

			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					include_surrounding_whitespace = true,
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

				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]f"] = "@function.outer",
					},

					goto_previous_start = {
						["[f"] = "@function.outer",
					},
				},

				lsp_interop = {
					enable = true,
					floating_preview_opts = {
						border = "single",
					},
					peek_definition_code = {
						["<Leader>df"] = "@function.outer",
						["<Leader>dc"] = "@class.outer",
					},
				},
			},
		})

		local ts_repeat = require("nvim-treesitter.textobjects.repeatable_move")

		keymap({ "n", "x", "o" }, ";", ts_repeat.repeat_last_move)
		keymap({ "n", "x", "o" }, ",", ts_repeat.repeat_last_move_opposite)
		keymap({ "n", "x", "o" }, "f", ts_repeat.builtin_f)
		keymap({ "n", "x", "o" }, "F", ts_repeat.builtin_F)
		keymap({ "n", "x", "o" }, "t", ts_repeat.builtin_t)
		keymap({ "n", "x", "o" }, "T", ts_repeat.builtin_T)
	end,
}
