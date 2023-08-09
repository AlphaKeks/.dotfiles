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
readdir = vim.fn.readdir
expand = vim.fn.expand
mode = vim.fn.mode
feedkeys = vim.fn.feedkeys
getline = vim.fn.getline
getcursorcharpos = vim.fn.getcursorcharpos
map = vim.fn.map
keytrans = vim.fn.keytrans

-- vim.F
if_nil = vim.F.if_nil

-- vim.api
set_hl = vim.api.nvim_set_hl
create_namespace = vim.api.nvim_create_namespace
input = vim.api.nvim_input
autocmd = vim.api.nvim_create_autocmd
open_win = vim.api.nvim_open_win
create_buf = vim.api.nvim_create_buf
buf_set_lines = vim.api.nvim_buf_set_lines
win_get_buf = vim.api.nvim_win_get_buf
win_close = vim.api.nvim_win_close
buf_set_extmark = vim.api.nvim_buf_set_extmark
buf_del_extmark = vim.api.nvim_buf_del_extmark
get_current_buf = vim.api.nvim_get_current_buf

---@param opts string | table augroup name or `vim.api.nvim_clear_autocmds` options
clear_autocmds = function(opts)
	if type(opts) == "string" then
		opts = { group = opts }
	end

	vim.api.nvim_clear_autocmds(opts)
end

augroup = function(name, opts)
	return vim.api.nvim_create_augroup(name, opts or { clear = true })
end

usercmd = function(name, cb, opts)
	return vim.api.nvim_create_user_command(name, cb, opts or {})
end

get_runtime_file = function(pattern, all)
	return vim.api.nvim_get_runtime_file(pattern, if_nil(all, true))
end

buf_delete = function(bufnr, opts)
	vim.api.nvim_buf_delete(bufnr, opts or {})
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

-- Other stuff

DOTFILES = os.getenv("HOME") .. "/.dotfiles"

---Merges two array-like tables
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
---@param command string | string[] List of command arguments
---@param callback fun(result: table)? Callback to run once the command finishes
---@param opts { sync: boolean?, ignore_errors: boolean?, error_msg: string? }?
---@return SystemCompleted? result Will only be returned if `sync` was `true`
run_shell = function(command, callback, opts)
	opts = opts or {}
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

---Fully reload a module (replacement for `require`)
function Reload(...)
	local plenary_installed, plenary = pcall(require, "plenary.reload")

	if plenary_installed then
		plenary.reload_module(...)
	end

	return require(...)
end
