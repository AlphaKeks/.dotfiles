-- Keymaps
keymap = vim.keymap.set

-- vim.cmd
colorscheme = vim.cmd.colorscheme
source = vim.cmd.source
copen = vim.cmd.copen
norm = vim.cmd.norm
new = vim.cmd.new
startinsert = vim.cmd.startinsert
edit = vim.cmd.edit
redrawstatus = vim.cmd.redrawstatus
tabe = vim.cmd.tabe
term = vim.cmd.term
wincmd = vim.cmd.wincmd

-- vim.fn
setqflist = vim.fn.setqflist
eval = vim.fn.luaeval
append = vim.fn.append
line = vim.fn.line
prompt_setcallback = vim.fn.prompt_setcallback
bufnr = vim.fn.bufnr
stdpath = vim.fn.stdpath
readfile = vim.fn.readfile
expand = vim.fn.expand
mode = vim.fn.mode
feedkeys = vim.fn.feedkeys
getline = vim.fn.getline
getcursorcharpos = vim.fn.getcursorcharpos

-- vim.F
if_nil = vim.F.if_nil

-- vim.api
set_hl = vim.api.nvim_set_hl
create_namespace = vim.api.nvim_create_namespace
autocmd = vim.api.nvim_create_autocmd
input = vim.api.nvim_input

augroup = function(name, opts)
	return vim.api.nvim_create_augroup(name, opts or { clear = true })
end

usercmd = function(name, cb, opts)
	return vim.api.nvim_create_user_command(name, cb, opts or {})
end

get_runtime_file = function(pattern, all)
	return vim.api.nvim_get_runtime_file(pattern, if_nil(all, true))
end

-- logging
vim.trace = function(msg, ...)
	return vim.notify(msg:format(...), vim.log.levels.TRACE)
end

vim.debug = function(msg, ...)
	return vim.notify(msg:format(...), vim.log.levels.DEBUG)
end

vim.info = function(msg, ...)
	return vim.notify(msg:format(...), vim.log.levels.INFO)
end

vim.warn = function(msg, ...)
	return vim.notify(msg:format(...), vim.log.levels.WARN)
end

vim.error = function(msg, ...)
	return vim.notify(msg:format(...), vim.log.levels.ERROR)
end

-- Tables

---Appends an array-like table to another
---@param tbl table Array-like table
---@param other table Array-like table
---@return table
vim.tbl_append = function(tbl, other)
	for _, v in ipairs(other) do
		table.insert(tbl, v)
	end

	return tbl
end

-- Other stuff
DOTFILES = os.getenv("HOME") .. "/.dotfiles"

---Run a shell command
---@param command string[] List of command arguments
---@param callback fun(result: table)? Callback to run once the command finishes
---@param opts { error_msg: string?, sync: boolean? }?
---@return SystemCompleted? result Will only be returned if `sync` was `true`
run_shell = function(command, callback, opts)
	opts = opts or {}

	if type(command) == "string" then
		command = { command }
	end

	local result = vim.system(command, { text = true }, vim.schedule_wrap(function(result)
		if result.code ~= 0 then
			local message = opts.error_msg or "Failed to run shell command"
			vim.error(message .. ": %s", vim.inspect(result))
			return
		end

		if callback then
			callback(result)
		end
	end))

	if opts.sync then
		return result:wait()
	end
end
