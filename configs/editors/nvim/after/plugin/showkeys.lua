ShowKeys = {
	bufnr = nil,
	win_id = nil,
	text = "",
	namespace = create_namespace("show-keys"),
	width = 40,
}

function ShowKeys:setup()
	self.bufnr = create_buf(false, true)
	self:create_window()

	vim.on_key(function(key)
		if not (self.bufnr and self.win_id) then
			return
		end

		self.text = self.text .. keytrans(key):lower()

		while #self.text > self.width do
			self.text = self.text:sub(2, #self.text)
		end

		buf_set_lines(self.bufnr, 0, -1, false, { self.text })
	end, self.namespace)
end

function ShowKeys:create_window()
	self.win_id = open_win(self.bufnr or 0, false, {
		title = "Keys",
		border = "rounded",
		style = "minimal",
		relative = "win",
		row = vim.o.lines - 4,
		col = vim.o.columns,
		anchor = "SE",
		width = self.width,
		height = 1,
		focusable = false,
		zindex = 69420,
	})
end

function ShowKeys:cleanup()
	buf_delete(win_get_buf(self.win_id))
	self.bufnr = nil
	self.win_id = nil
	self.history = {}
end

usercmd("ShowKeys", function()
	ShowKeys:setup()
end)

usercmd("HideKeys", function()
	ShowKeys:cleanup()
end)

return ShowKeys
