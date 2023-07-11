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
				path_display = { "smart" },
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

			return vim.tbl_deep_extend("force", ret, opts or {})
		end

		keymap("n", "<C-f>", function()
			pickers.current_buffer_fuzzy_find(ivy())
		end)

		keymap("n", "<Leader>ff", function()
			local opts = ivy({
				hidden = true,
				follow = true,
				show_untracked = true,
				file_ignore_patterns = {
					"zsh/plugins/*",
					"%.png",
					"%.svg",
					"%.ttf",
					"%.otf",
					"%.lock",
					"%-lock.json",
					"%.wasm",
					".direnv/*",
					"node_modules/*",
					"dist/*",
				},
			})

			if not pcall(pickers.git_files, opts) then
				pickers.find_files(opts)
			end
		end)

		keymap("n", "<Leader>fb", function()
			pcall(pickers.buffers, ivy({
				initial_mode = "normal",
			}))
		end)

		keymap("n", "<Leader>fh", function()
			pickers.help_tags(ivy())
		end)

		keymap("n", "<Leader>fl", function()
			pickers.live_grep(ivy())
		end)

		keymap("n", "<Leader>fd", function()
			pickers.diagnostics(ivy())
		end)

		keymap("n", "<Leader>fk", function()
			pickers.keymaps(ivy())
		end)

		keymap("n", "<Leader>fa", function()
			pickers.autocommands(ivy())
		end)

		keymap("n", "<Leader>ft", function()
			pickers.filetypes(ivy())
		end)

		keymap("n", "<Leader>fr", function()
			pickers.lsp_references(ivy())
		end)

		keymap("n", "<Leader>gd", function()
			pickers.lsp_definitions(ivy())
		end)

		keymap("n", "<Leader>fs", function()
			pickers.lsp_workspace_symbols(ivy())
		end)

		keymap("n", "<Leader>fi", function()
			pickers.lsp_implementations(ivy())
		end)

		keymap("n", "<Leader>fg", function()
			pcall(pickers.git_commits, {
				initial_mode = "normal",
				layout_config = {
					height = 0.9,
					width = 0.9,
				},
			})
		end)

		keymap("n", "<Leader>gs", function()
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
