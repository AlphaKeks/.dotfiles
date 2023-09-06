keymap = vim.keymap.set
if_nil = vim.F.if_nil

---@param message string
vim.trace = function(message, ...)
	return vim.notify(message:format(...), vim.log.levels.TRACE)
end

---@param message string
vim.debug = function(message, ...)
	return vim.notify(message:format(...), vim.log.levels.DEBUG)
end

---@param message string
vim.info = function(message, ...)
	return vim.notify(message:format(...), vim.log.levels.INFO)
end

---@param message string
vim.warn = function(message, ...)
	return vim.notify(message:format(...), vim.log.levels.WARN)
end

---@param message string
vim.error = function(message, ...)
	return vim.notify(message:format(...), vim.log.levels.ERROR)
end

vim.tbl_concat = function(tbl, ...)
	local new = vim.deepcopy(tbl)

	for _, t in ipairs({ ... }) do
		for _, element in ipairs(t) do
			table.insert(new, element)
		end
	end

	return new
end

copen = vim.cmd.copen
edit = vim.cmd.edit
norm = vim.cmd.norm
redrawstatus = vim.cmd.redrawstatus
source = vim.cmd.source

col = vim.fn.col
complete = vim.fn.complete
complete_info = vim.fn.complete_info
expand = vim.fn.expand
line = vim.fn.line
match = vim.fn.match
matchfuzzy = vim.fn.matchfuzzy
pumvisible = vim.fn.pumvisible
readdir = vim.fn.readdir
readfile = vim.fn.readfile
setqflist = vim.fn.setqflist
stdpath = vim.fn.stdpath

nvim_buf_get_lines = vim.api.nvim_buf_get_lines
nvim_buf_set_lines = vim.api.nvim_buf_set_lines
nvim_clear_autocmds = vim.api.nvim_clear_autocmds
nvim_create_namespace = vim.api.nvim_create_namespace
nvim_feedkeys = vim.api.nvim_feedkeys
nvim_get_current_buf = vim.api.nvim_get_current_buf
nvim_get_current_line = vim.api.nvim_get_current_line
nvim_get_current_win = vim.api.nvim_get_current_win
nvim_get_mode = vim.api.nvim_get_mode
nvim_input = vim.api.nvim_input
nvim_replace_termcodes = vim.api.nvim_replace_termcodes
nvim_set_hl = vim.api.nvim_set_hl
nvim_win_get_cursor = vim.api.nvim_win_get_cursor

autocmd = function(events, options)
	return vim.api.nvim_create_autocmd(events, options)
end

augroup = function(name, options)
	return vim.api.nvim_create_augroup(name, if_nil(options, { clear = true }))
end

command = function(name, command, options)
	options = if_nil(options, {})

	if options.buffer then
		options.buffer = nil
		local buffer = nvim_get_current_buf()
		return vim.api.nvim_buf_create_user_command(buffer, name, command, options)
	else
		return vim.api.nvim_create_user_command(name, command, options)
	end
end

nvim_get_runtime_file = function(pattern, all)
	return vim.api.nvim_get_runtime_file(pattern, if_nil(all, true))
end

Reload = function(...)
	local plenary_installed, plenary = pcall(require, "plenary.reload")

	if plenary_installed then
		plenary.reload_module(...)
	end
end

Require = function(...)
	Reload(...)
	return require(...)
end

SendToQf = function(content, options)
	if not content then
		return content
	end

	options = if_nil(options, {})
	options.title = if_nil(options.title, "Quickfix")

	local is_string = type(content) == "string"
	local is_table = type(content) == "table"
	local is_array = is_table and vim.tbl_isarray(content)

	local items = {}

	if is_string then
		items = vim.tbl_map(function(line)
			return { text = line }
		end, vim.split(content, "\n", { trimempty = true }))
	elseif is_array then
		items = vim.tbl_map(function(item)
			return { text = item }
		end, content)
	elseif is_table then
		items = vim.tbl_map(function(line)
			return { text = line }
		end, vim.split(vim.inspect(content), "\n", { trimempty = true }))
	else
		vim.error("Invalid type to send to the quickfix list! (%s)", type(content))
		return content
	end

	local is_empty = true

	for _, item in ipairs(items) do
		if #item.text > 0 then
			is_empty = false
			break
		end
	end

	if is_empty then
		return
	end

	vim.schedule(function()
		setqflist({}, "r", { items = items, title = options.title })
		copen()
		nvim_input("G<CR>")
	end)

	return content
end

---@param command string[] | string
---@param callback fun(result: SystemCompleted)?
---@param options table?
System = function(command, callback, options)
	local cmd = {}

	if type(command) == "string" then
		cmd = vim.split(command, " ")
	else
		cmd = command
	end

	options = if_nil(options, {})
	options.sync = if_nil(options.sync, false)
	options.text = if_nil(options.text, true)

	local result = vim.system(cmd, options, vim.schedule_wrap(function(result)
		if callback then
			callback(result)
		end
	end))

	if options.sync then
		return result:wait()
	end
end
