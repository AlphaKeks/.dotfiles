-- https://GitHub.com/AlphaKeks/.dotfiles

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazy_path) then
	vim.fn.system({
		"git", "clone", "--branch=stable",
		"https://github.com/folke/lazy.nvim",
		lazy_path,
	})

	vim.notify("Installed lazy.nvim")
end

vim.opt.rtp:prepend(lazy_path)

local lazy_installed, lazy = pcall(require, "lazy")

if not lazy_installed then
	vim.notify("lazy.nvim is not installed.")
	vim.notify("Plugins will be disabled.")
	return
end

lazy.setup({
	defaults = {
		lazy = false,
	},

	spec = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-tree/nvim-web-devicons",
		"nvim-treesitter/nvim-treesitter",
		"nvim-treesitter/nvim-treesitter-textobjects",
		"numToStr/Comment.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lsp",
		"L3MON4D3/LuaSnip",
		"stevearc/oil.nvim",
	},

	concurrency = 69,

	install = {
		missing = true,
		colorscheme = { "catppuccin", "habamax", "quiet" },
	},

	ui = {
		wrap = true,
		border = "solid",
		browser = "firefox",
	},

	performance = {
		cache = {
			enabled = true,
		},

		reset_packpath = true,

		rtp = {
			reset = false,
		},
	},
})

