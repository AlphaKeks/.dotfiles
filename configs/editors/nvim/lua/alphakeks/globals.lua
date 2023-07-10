-- https://GitHub.com/AlphaKeks/.dotfiles

keymap = vim.keymap.set

source = vim.cmd.source
stopinsert = vim.cmd.stopinsert
startinsert = vim.cmd.startinsert
write = vim.cmd.write
edit = vim.cmd.edit
redrawstatus = vim.cmd.redrawstatus
copen = vim.cmd.copen
new = vim.cmd.new
resize = vim.cmd.resize
norm = vim.cmd.norm

expand = vim.fn.expand
readfile = vim.fn.readfile
mode = vim.fn.mode
pum_getpos = vim.fn.pum_getpos
pumvisible = vim.fn.pumvisible
stdpath = vim.fn.stdpath
setqflist = vim.fn.setqflist
luaeval = vim.fn.luaeval
line = vim.fn.line
append = vim.fn.append
prompt_setcallback = vim.fn.prompt_setcallback

create_namespace = vim.api.nvim_create_namespace
set_hl = vim.api.nvim_set_hl
win_get_cursor = vim.api.nvim_win_get_cursor
get_current_line = vim.api.nvim_get_current_line
feedkeys = vim.api.nvim_feedkeys
replace_termcodes = vim.api.nvim_replace_termcodes
buf_delete = vim.api.nvim_buf_delete
buf_get_lines = vim.api.nvim_buf_get_lines
buf_set_lines = vim.api.nvim_buf_set_lines
get_current_buf = vim.api.nvim_get_current_buf
autocmd = vim.api.nvim_create_autocmd

function augroup(name, opts)
	return vim.api.nvim_create_augroup(name, opts or { clear = true })
end

function usercmd(name, callback, opts)
	return vim.api.nvim_create_user_command(name, callback, opts or {})
end

vim.trace = function(msg)
	vim.notify(msg, vim.log.levels.TRACE)
end

vim.debug = function(msg)
	vim.notify(msg, vim.log.levels.DEBUG)
end

vim.info = function(msg)
	vim.notify(msg, vim.log.levels.INFO)
end

vim.warn = function(msg)
	vim.notify(msg, vim.log.levels.WARN)
end

vim.error = function(msg)
	vim.notify(msg, vim.log.levels.ERROR)
end

function Reload(...)
	local plenary_installed, plenary = pcall(require, "plenary.reload")

	if plenary_installed then
		plenary.reload_module(...)
	end

	return require(...)
end

function Print(input, use_qf_list)
	if not input then
		return input
	end

	local is_table = type(input) == "table"
	local is_string = type(input) == "string"

	if not (is_table or is_string) then
		return input
	end

	local src = ""
	if type(input) == "table" and not vim.tbl_isempty(input) then
		src = vim.inspect(input)
	elseif type(input) == "string" and #input > 0 then
		src = input
	end

	if #src == 0 then
		return
	end

	local lines = {}

	for line in vim.gsplit(src, "\n") do
		if #line > 0 then
			if use_qf_list then
				line = { text = line:gsub("\t", "  ") }
			end

			table.insert(lines, line)
		end
	end

	if use_qf_list then
		setqflist({}, "r", { items = lines, title = "Messages" })
		copen()
	else
		new()
		resize(-10)
		vim.bo.buftype = "nofile"
		vim.bo.bufhidden = "hide"
		vim.bo.buflisted = false
		buf_set_lines(0, 0, -1, false, lines)
	end

	norm("G")

	return input
end

---THIS DOES NOT WORK
function Repl()
	local function callback(text)
		local result = luaeval(text)
		local line = line("$")
		append(line - 1, result or "")
	end

	new()
	vim.bo.buftype = "prompt"
	prompt_setcallback(get_current_buf(), callback)
	keymap("n", "<ESC>", "<CMD>bw!<CR>", { buffer = true, silent = true })
	startinsert()
end
