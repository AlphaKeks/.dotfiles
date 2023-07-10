return {
	"folke/neodev.nvim",

	config = function()
		local neodev = require("neodev")

		neodev.setup({
			lspconfig = false,
		})
	end,
}
