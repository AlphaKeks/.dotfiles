return {
	"NeogitOrg/neogit",

	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"sindrets/diffview.nvim",
			lazy = true,
		}
	},

	keys = {
		{ "<Leader>gs", "<CMD>Neogit<CR>" },
	},

	config = function()
		local neogit = require("neogit")

		neogit.setup({
			disable_context_highlighting = true,
			disable_commit_confirmation = true,
			popup = {
				kind = "vsplit",
			},
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
	end,
}
