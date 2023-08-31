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
_G.Reload = function(...)
	local plenary_installed, plenary = pcall(require, "plenary.reload")

	if plenary_installed then
		plenary.reload_module(...)
	end
end

---Fully reload a module and re-require it
_G.Require = function(...)
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
---@param opts { sync: boolean?, ignore_errors: boolean?, cmd: SystemOpts? }? Extra options
---@return SystemCompleted? result Will only be returned if `opts.sync` was `true`
_G.System = function(command, callback, opts)
	opts = if_nil(opts, {})
	opts.sync = if_nil(opts.sync, false)
	opts.ignore_errors = if_nil(opts.ignore_errors, false)
	opts.cmd = if_nil(opts.cmd, {})

	if type(command) == "string" then
		command = { command }
	end

	local cmd_opts = vim.tbl_deep_extend("force", { text = true }, opts.cmd)

	local result = vim.system(command, cmd_opts, vim.schedule_wrap(function(result)
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
split = vim.cmd.split
startinsert = vim.cmd.startinsert
tabe = vim.cmd.tabe
term = vim.cmd.term
vnew = vim.cmd.new
vsplit = vim.cmd.vsplit
wincmd = vim.cmd.wincmd

-- vim.fn
append = vim.fn.append
bufnr = vim.fn.bufnr
col = vim.fn.col
complete = vim.fn.complete
expand = vim.fn.expand
getline = vim.fn.getline
keytrans = vim.fn.keytrans
line = vim.fn.line
luaeval = vim.fn.luaeval
match = vim.fn.match
mode = vim.fn.mode
prompt_setcallback = vim.fn.prompt_setcallback
pum_getpos = vim.fn.pum_getpos
pumvisible = vim.fn.pumvisible
readdir = vim.fn.readdir
readfile = vim.fn.readfile
setqflist = vim.fn.setqflist
stdpath = vim.fn.stdpath
tolower = vim.fn.tolower
writefile = vim.fn.writefile

-- vim.api
for name, value in pairs(vim.api) do
	_G[name] = value
end

_G.autocmd = function(events, opts)
	return vim.api.nvim_create_autocmd(events, opts)
end

_G.augroup = function(name, opts)
	return vim.api.nvim_create_augroup(name, if_nil(opts, { clear = true }))
end

_G.nvim_clear_autocmds = function(opts)
	if type(opts) == "string" then
		opts = { group = opts }
	end

	return vim.api.nvim_clear_autocmds(opts)
end

_G.usercmd = function(name, command, opts)
	return vim.api.nvim_create_user_command(name, command, if_nil(opts, {}))
end

_G.buf_usercmd = function(buf, name, command, opts)
	return vim.api.nvim_buf_create_user_command(buf, name, command, if_nil(opts, {}))
end

_G.nvim_get_runtime_file = function(pattern, all)
	return vim.api.nvim_get_runtime_file(pattern, if_nil(all, true))
end

_G.nvim_buf_delete = function(bufnr, opts)
	vim.api.nvim_buf_delete(bufnr, if_nil(opts, {}))
end
