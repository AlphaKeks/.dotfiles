return {
	dir = vim.env.HOME .. "/Projects/balls.nvim",
	config = function()
		local balls = require("balls")

		keymap("i", "<CR>", function()
			if vim.fn.pumvisible() == 0 then
				local enter = nvim_replace_termcodes("<CR>", true, false, true)
				nvim_feedkeys(enter, "n", false)
			else
				balls.import_current_item()
			end
		end)
	end,
}
