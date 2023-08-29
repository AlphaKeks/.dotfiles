return {
	dir = vim.env.HOME .. "/Projects/harpoon",
	enabled = false,

	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()
	end,
}
