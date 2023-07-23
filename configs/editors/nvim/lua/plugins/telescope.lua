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
				selection_caret = "=>",

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

		local stupid_files = {
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
			".git/*",
			"desktop/icons/*",
		}

		keymap("n", "<C-f>", function()
			pickers.current_buffer_fuzzy_find(ivy())
		end)

		local function search_dotfiles(subdir)
			subdir = subdir or ""
			pickers.find_files(ivy({
				prompt_title = ".dotfiles" .. subdir,
				hidden = true,
				follow = true,
				cwd = DOTFILES .. subdir,
				file_ignore_patterns = vim.tbl_append(stupid_files, {
					"%.xml",
					"%.css",
					"%.tmTheme",
				}),
			}))
		end

		keymap("n", "<Leader>df", search_dotfiles)

		keymap("n", "<Leader>nf", function()
			search_dotfiles("/configs/editors")
		end)

		keymap("n", "<Leader>ff", function()
			-- Make `<Leader>ff` equivalent to `<Leader>df` when I'm in my dotfiles directory.
			if vim.startswith(expand("%:p:h"), DOTFILES) then
				return search_dotfiles()
			end

			local opts = ivy({
				hidden = true,
				follow = true,
				show_untracked = true,
				file_ignore_patterns = stupid_files,
			})

			-- Try to search git files first.
			-- If we're not in a git directory, fall back to normal `find_files`.
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

		keymap("n", "<C-/>", function()
			pickers.grep_string(ivy())
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
	end,
}
