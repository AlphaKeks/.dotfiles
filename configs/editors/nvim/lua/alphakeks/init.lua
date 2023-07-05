-- https://GitHub.com/AlphaKeks/.dotfiles

-- Load global variables
require("alphakeks.globals")

autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ timeout = 69 })
	end,
})

autocmd("TermOpen", {
	command = "setl nonu rnu so=0",
})

-- Plugins
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazy_path) then
	vim.system({
		"git", "clone", "--branch=stable",
		"https://github.com/folke/lazy.nvim",
		lazy_path,
	}):wait()

	vim.notify("Installed lazy.nvim", vim.log.levels.INFO)
end

vim.opt.rtp:prepend(lazy_path)

local lazy_installed, lazy = pcall(require, "lazy")

if not lazy_installed then
	vim.notify("lazy.nvim is not installed.", vim.log.levels.WARN)
	vim.notify("Plugins will be disabled.", vim.log.levels.WARN)
	return
end

lazy.setup("plugins", {
	defaults = {
		lazy = false,
	},

	install = {
		missing = true,
		colorscheme = { "dawn", "catppuccin", "habamax" },
	},

	ui = {
		wrap = true,
		border = "solid",
	},

	change_detection = {
		notify = false,
	},

	performance = {
		rtp = {
			reset = false,
		},
	},
})
