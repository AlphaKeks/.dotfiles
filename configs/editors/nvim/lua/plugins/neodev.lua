return {
	"folke/neodev.nvim",

	ft = "lua",
	config = function()
		local neodev = require("neodev")

		neodev.setup({
			lspconfig = false,
		})
	end,
}
