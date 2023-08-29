local balls_installed, balls = pcall(require, "balls")

if not balls_installed then
	return
end

keymap("i", "<CR>", function()
	if vim.fn.pumvisible() == 0 then
		local enter = nvim_replace_termcodes("<CR>", true, false, true)
		nvim_feedkeys(enter, "n", false)
	else
		balls.import_current_item()
	end
end)
