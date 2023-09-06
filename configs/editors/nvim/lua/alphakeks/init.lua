require("alphakeks.globals")

autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ timeout = 150 })
	end,
})

command("Messages", function()
	vim.cmd("redir => g:messages | silent! messages | redir end")
	SendToQf(vim.g.messages, { title = "Messages" })
end)

local add_remote = require("alphakeks.plugins").add_remote

add_remote("nvim-lua/plenary.nvim")
add_remote("nvim-telescope/telescope.nvim")
add_remote("nvim-telescope/telescope-ui-select.nvim")
add_remote("nvim-telescope/telescope-fzf-native.nvim", { on_sync = "make" })
add_remote("nvim-treesitter/nvim-treesitter", { on_sync = ":TSUpdate all" })
add_remote("nvim-treesitter/nvim-treesitter-textobjects")
add_remote("numToStr/Comment.nvim")
add_remote("stevearc/oil.nvim")
add_remote("tpope/vim-fugitive")
