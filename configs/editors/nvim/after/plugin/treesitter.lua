local treesitter_installed, treesitter = pcall(require, "nvim-treesitter.configs")

if not treesitter_installed then
	return
end

treesitter.setup({
	ensure_installed = { "vim", "vimdoc", "bash", "comment", "lua", "rust" },
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
				["<Leader>dc"] = "@class.outer",
			},
		},
	},
})
