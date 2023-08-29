ShowKeys = {
	bufnr = nil,
	win_id = nil,
	text = "",
	namespace = nvim_create_namespace("show-keys"),
	width = 40,
	already_setup = false,
	running = true,
	opts = {},
}

---@param opts { display?: "window" | "winbar" }
ShowKeys.setup = function(self, opts)
	opts = if_nil(opts, {})
	opts.display = if_nil(opts.display, "window")
	self.opts = opts

	if self.already_setup then
		self:close_window()
	end

	if self.opts.display == "window" then
		self:show_window()
	elseif self.opts.display == "winbar" then
	else
		vim.error("Invalid `display`: %s", vim.inspect(self.opts.display))
		return
	end

	self.running = true

	if self.already_setup then
		return
	end

	vim.on_key(function(key)
		if not self.running then
			return
		end

		self.text = self.text .. keytrans(key)

		while #self.text > self.width do
			self.text = self.text:sub(2, #self.text)
		end

		if self.opts.display == "window" and self.bufnr and self.win_id then
			nvim_buf_set_lines(self.bufnr, 0, -1, false, { self.text })
		elseif self.opts.display == "winbar" then
			redrawstatus()
		end
	end, self.namespace)

	self.already_setup = true
end

ShowKeys.create_window = function(self)
	self.win_id = nvim_open_win(self.bufnr or 0, false, {
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

ShowKeys.show_window = function(self)
	self.bufnr = nvim_create_buf(false, true)
	self:create_window()
end

ShowKeys.close_window = function(self)
	if self.win_id then
		nvim_buf_delete(nvim_win_get_buf(self.win_id))
	end

	self.bufnr = nil
	self.win_id = nil
end

usercmd("ShowKeysStart", function(cmd)
	local display = if_nil(cmd.fargs[1], "window")
	ShowKeys:setup({ display = display })
end, {
	nargs = "?",
	complete = function()
		return { "window", "winbar" }
	end,
})

usercmd("ShowKeysStop", function()
	ShowKeys:close_window()
	ShowKeys.running = false
	ShowKeys.text = ""
	redrawstatus()
end)

return ShowKeys
