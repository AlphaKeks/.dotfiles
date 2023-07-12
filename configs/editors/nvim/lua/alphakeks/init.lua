-- https://GitHub.com/AlphaKeks/.dotfiles

-- Load global variables
require("alphakeks.globals")

keymap("n", "<C-s>", write)

autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ timeout = 69 })
	end,
})

autocmd("TermOpen", { command = "setl nonu rnu so=0" })

usercmd("Messages", function(opts)
	vim.cmd("redir => g:messages | silent! messages | redir END")
	Print(vim.g.messages, opts.args == "qf")
	vim.g.messages = nil
end, { nargs = "?" })

usercmd("SourceOnSave", function()
	local bufnr = get_current_buf()
	local filename = expand("%:t")

	autocmd("BufWritePost", {
		buffer = bufnr,
		group = augroup(filename .. "-reload-on-save"),
		callback = function()
			source("%")
			print("Reloaded.")
		end,
	})
end)

if os.getenv("CMP") then
	require("scratch.completion"):setup()
end

-- Plugins
local lazy_path = stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazy_path) then
	vim.system({
		"git", "clone", "--branch=stable",
		"https://github.com/folke/lazy.nvim",
		lazy_path,
	}):wait()

	vim.info("Installed lazy.nvim")
end

vim.opt.rtp:prepend(lazy_path)

local lazy_installed, lazy = pcall(require, "lazy")

if not lazy_installed then
	vim.warn("lazy.nvim is not installed.")
	vim.warn("Plugins will be disabled.")
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
