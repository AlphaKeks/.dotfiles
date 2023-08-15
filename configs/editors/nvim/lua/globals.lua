DOTFILES = os.getenv("HOME") .. "/.dotfiles"

keymap = vim.keymap.set
if_nil = vim.F.if_nil

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

---Fully reload a module
function Reload(...)
	local plenary_installed, plenary = pcall(require, "plenary.reload")

	if plenary_installed then
		plenary.reload_module(...)
	end
end

---Fully reload a module and re-require it
function Require(...)
	Reload(...)
	return require(...)
end

---Merges two array-like tables
---
---@param tbl any[]
---@param other any[]
---@return table
vim.tbl_merge = function(tbl, other)
	tbl = vim.deepcopy(tbl)
	for _, v in ipairs(other) do
		table.insert(tbl, v)
	end

	return tbl
end

---Run a shell command
---
---@param command string | string[] List of command arguments
---@param callback fun(result: table)? Callback to run once the command finishes
---@param opts { sync: boolean?, ignore_errors: boolean?, error_msg: string? }?
---@return SystemCompleted? result Will only be returned if `sync` was `true`
function System(command, callback, opts)
	opts = if_nil(opts, {})
	opts.sync = if_nil(opts.sync, false)
	opts.ignore_errors = if_nil(opts.ignore_errors, false)

	if type(command) == "string" then
		command = { command }
	end

	local result = vim.system(command, { text = true }, vim.schedule_wrap(function(result)
		if (not opts.ignore_errors) and result.code ~= 0 then
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

-- vim.cmd
colorscheme = vim.cmd.colorscheme
copen = vim.cmd.copen
edit = vim.cmd.edit
new = vim.cmd.new
norm = vim.cmd.norm
redrawstatus = vim.cmd.redrawstatus
source = vim.cmd.source
startinsert = vim.cmd.startinsert
tabe = vim.cmd.tabe
term = vim.cmd.term
wincmd = vim.cmd.wincmd

-- vim.fn
append = vim.fn.append
bufnr = vim.fn.bufnr
col = vim.fn.col
expand = vim.fn.expand
getline = vim.fn.getline
keytrans = vim.fn.keytrans
line = vim.fn.line
luaeval = vim.fn.luaeval
mode = vim.fn.mode
prompt_setcallback = vim.fn.prompt_setcallback
pum_getpos = vim.fn.pum_getpos
pumvisible = vim.fn.pumvisible
readdir = vim.fn.readdir
readfile = vim.fn.readfile
setqflist = vim.fn.setqflist
stdpath = vim.fn.stdpath
writefile = vim.fn.writefile

-- vim.api
for name, value in pairs(vim.api) do
	_G[name] = value
end

autocmd = function(events, opts)
	return vim.api.nvim_create_autocmd(events, opts)
end

augroup = function(name, opts)
	return vim.api.nvim_create_augroup(name, if_nil(opts, { clear = true }))
end

nvim_clear_autocmds = function(opts)
	if type(opts) == "string" then
		opts = { group = opts }
	end

	return vim.api.nvim_clear_autocmds(opts)
end

usercmd = function(name, command, opts)
	return vim.api.nvim_create_user_command(name, command, if_nil(opts, {}))
end

nvim_get_runtime_file = function(pattern, all)
	return vim.api.nvim_get_runtime_file(pattern, if_nil(all, true))
end

nvim_buf_delete = function(bufnr, opts)
	vim.api.nvim_buf_delete(bufnr, if_nil(opts, {}))
end
