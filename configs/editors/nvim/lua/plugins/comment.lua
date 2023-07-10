return {
	"numToStr/Comment.nvim",

	config = function()
		local comment = require("Comment")

		comment.setup({
			toggler = {
				line = "<Leader>cc",
				block = "<Leader>cb",
			},

			opleader = {
				line = "<Leader>c",
			},

			mappings = {
				basic = true,
				extra = false,
			},
		})
	end,
}
