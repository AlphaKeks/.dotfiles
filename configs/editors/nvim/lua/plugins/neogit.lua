return {
	"NeogitOrg/neogit",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
	},

	config = function()
		local neogit = require("neogit")

		neogit.setup({
			disable_context_highlighting = true,
			disable_commit_confirmation = true,
			commit_popup = {
				kind = "vsplit",
			},
			signs = {
				section = { "", "" },
				item = { "", "" },
			},
			integrations = {
				telescope = true,
				diffview = true,
			},
		})

		keymap("n", "<Leader>gs", neogit.open)
	end,
}
