return {
	"NeogitOrg/neogit",

	config = function()
		local neogit = require("neogit")

		neogit.setup({
			use_telescope = true,
			signs = {
				section = { "", "" },
				item = { "", "" },
			},
		})

		keymap("n", "<Leader>gs", neogit.open)
	end,
}
