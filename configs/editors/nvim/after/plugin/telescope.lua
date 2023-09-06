local telescope_installed, telescope = pcall(require, "telescope")

if not telescope_installed then
	return
end

local actions = require("telescope.actions")
local themes = require("telescope.themes")

local ivy = function(options)
	local defaults = themes.get_ivy({
		layout_config = {
			height = 0.3,
		},
	})

	return vim.tbl_deep_extend("force", defaults, if_nil(options, {}))
end

local ivy_tall = function(options)
	local defaults = {
		initial_mode = "normal",
		layout_config = {
			height = 0.5,
			width = 0.5,
		},
	}

	return ivy(vim.tbl_deep_extend("force", defaults, if_nil(options, {})))
end

telescope.setup({
	defaults = {
		winblend = 10,
		selection_caret = "-> ",
		border = false,
		dynamic_preview_title = true,
		mappings = {
			["n"] = {
				["q"] = actions.close
			},

			["i"] = {
				["<Esc>"] = actions.close,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-s>"] = actions.file_split,
				["<C-Space>"] = actions.to_fuzzy_refine,
			},
		},
		color_devicons = false,
		file_ignore_patterns = {
			"^node_modules/",
			"^dist/",
			"^.git/",
			"^.direnv/",
			"^.sqlx/",
			"^zsh/plugins/",
			"^desktop/icons/",
			"%.png",
			"%.jpg",
			"%.jpeg",
			"%.svg",
			"%.ttf",
			"%.otf",
			"%.lock",
			"%-lock.json",
			"%.wasm",
			"%.xml",
			"%.css",
			"%.tmTheme",
		},
	},

	pickers = {
		["autocommands"] = ivy(),
		["buffers"] = ivy({ initial_mode = "normal" }),
		["commands"] = ivy(),
		["git_commits"] = ivy_tall(),
		["grep_string"] = ivy(),
		["help_tags"] = ivy(),
		["highlights"] = ivy(),
		["keymaps"] = ivy(),
		["live_grep"] = ivy_tall({ initial_mode = "insert" }),
		["lsp_workspace_symbols"] = ivy(),
		["lsp_implementations"] = ivy(),
		["lsp_references"] = ivy(),
		["quickfix"] = ivy(),
		["git_files"] = ivy(),
		["find_files"] = ivy(),
		["diagnostics"] = ivy(),
	},

	extensions = {
		["ui-select"] = {
			themes.get_cursor(),
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")

local pickers = require("telescope.builtin")

-- builtins
keymap("n", "<Leader>fa", pickers.autocommands)
keymap("n", "<Leader>fb", pickers.buffers)
keymap("n", "<Leader>fc", pickers.commands)
keymap("n", "<C-f>", pickers.current_buffer_fuzzy_find)
keymap("n", "<Leader>fg", pickers.git_commits)
keymap("n", "<Leader>fw", pickers.grep_string)
keymap("n", "<Leader>fht", pickers.help_tags)
keymap("n", "<Leader>fhi", pickers.highlights)
keymap("n", "<Leader>fk", pickers.keymaps)
keymap("n", "<Leader>fl", pickers.live_grep)
keymap("n", "<Leader>fs", pickers.lsp_workspace_symbols)
keymap("n", "<Leader>fi", pickers.lsp_implementations)
keymap("n", "<Leader>fr", pickers.lsp_references)
keymap("n", "<Leader>fq", pickers.quickfix)

-- custom
keymap("n", "<Leader>fd", function()
	-- FIXME: <https://github.com/nvim-telescope/telescope.nvim/issues/2661>
	pickers.diagnostics({ severity_bound = "ERROR" })
end)

local find_dotfiles = function(subdir)
	pickers.find_files({
		prompt_title = "~ dotfiles ~",
		hidden = true,
		follow = true,
		cwd = vim.env.HOME .. "/.dotfiles/" .. if_nil(subdir, ""),
	})
end

keymap("n", "<Leader>df", find_dotfiles)

keymap("n", "<Leader>fn", function()
	find_dotfiles("/configs/editors")
end)

keymap("n", "<Leader>ff", function()
	local cwd = expand("%:p:h")

	if vim.startswith(cwd, vim.env.HOME .. "/.dotfiles") then
		return find_dotfiles()
	end

	local options = {
		hidden = true,
		follow = true,
		show_untracked = true,
	}

	if not pcall(pickers.git_files, options) then
		pickers.find_files(options)
	end
end)

keymap("n", "<Leader>fhh", function()
	pickers.grep_string(themes.get_dropdown({
		prompt_title = "Help",
		search = "",
		search_dirs = nvim_get_runtime_file("doc/*.txt"),
		only_sort_text = true,
		disable_coordinates = true,
		path_display = "hidden",
		layout_config = {
			anchor = "S",
			prompt_position = "bottom",
			height = 0.35,
			width = 0.9,
		},
	}))
end)
