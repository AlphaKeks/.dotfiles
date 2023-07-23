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

-- vim.api
set_hl = vim.api.nvim_set_hl
create_namespace = vim.api.nvim_create_namespace
autocmd = vim.api.nvim_create_autocmd
augroup = function(name, opts)
	return vim.api.nvim_create_augroup(name, opts or { clear = true })
end
usercmd = function(name, cb, opts)
	return vim.api.nvim_create_user_command(name, cb, opts or {})
end
nvim_input = vim.api.nvim_input

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

-- Lua builtins
format = string.format

-- Other stuff
DOTFILES = os.getenv("HOME") .. "/.dotfiles"
