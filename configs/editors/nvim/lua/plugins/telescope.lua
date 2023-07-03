return {
	"nvim-telescope/telescope.nvim",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
	},

	config = function()
		local telescope = require("telescope")
		local pickers = require("telescope.builtin")
		local themes = require("telescope.themes")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "shorten" },
				prompt_prefix = "  ",

				mappings = {
					["i"] = {
						["<ESC>"] = actions.close,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					},
				},
			},

			extensions = {
				["ui-select"] = {
					themes.get_cursor(),
				},
			},
		})

		telescope.load_extension("ui-select")

		local function ivy(opts)
			local ret = themes.get_ivy({
				layout_config = {
					height = 0.4,
				},
			})

			for key, value in pairs(opts or {}) do
				ret[key] = value
			end

			return ret
		end

		vim.keymap.set("n", "<C-f>", function()
			pickers.current_buffer_fuzzy_find(ivy())
		end)

		vim.keymap.set("n", "<Leader>ff", function()
			local opts = ivy({
				hidden = true,
				follow = true,
				show_untracked = true,
				file_ignore_patterns = {
					"zsh/plugins/*",
					"%.lock",
					"%-lock.json",
					"%.wasm",
					".direnv/*"
				},
			})

			if not pcall(pickers.git_files, opts) then
				pickers.find_files(opts)
			end
		end)

		vim.keymap.set("n", "<Leader>fb", function()
			pcall(pickers.buffers, ivy({
				initial_mode = "normal",
			}))
		end)

		vim.keymap.set("n", "<Leader>fh", function()
			pickers.help_tags(ivy())
		end)

		vim.keymap.set("n", "<Leader>fl", function()
			pickers.live_grep(ivy())
		end)

		vim.keymap.set("n", "<Leader>fd", function()
			pickers.diagnostics(ivy())
		end)

		vim.keymap.set("n", "<Leader>fr", function()
			pickers.lsp_references(ivy())
		end)

		vim.keymap.set("n", "<Leader>gd", function()
			pickers.lsp_definitions(ivy())
		end)

		vim.keymap.set("n", "<Leader>fs", function()
			pickers.lsp_workspace_symbols(ivy())
		end)

		vim.keymap.set("n", "<Leader>fi", function()
			pickers.lsp_implementations(ivy())
		end)

		vim.keymap.set("n", "<Leader>fg", function()
			pcall(pickers.git_commits, {
				initial_mode = "normal",
				layout_config = {
					height = 0.9,
					width = 0.9,
				},
			})
		end)

		vim.keymap.set("n", "<Leader>gs", function()
			pcall(pickers.git_status, {
				initial_mode = "normal",
				layout_config = {
					height = 0.9,
					width = 0.9,
				},
			})
		end)
	end,
}
