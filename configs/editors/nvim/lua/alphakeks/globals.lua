-- https://GitHub.com/AlphaKeks/.dotfiles

autocmd = vim.api.nvim_create_autocmd
augroup = function(name, opts)
	return vim.api.nvim_create_augroup(name, opts or { clear = true })
end

function usercmd(name, callback, opts)
	vim.api.nvim_create_user_command(name, callback, opts or {})
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
	elseif type(input) == "string" and input:len() > 0 then
		src = input
	end

	if src:len() == 0 then
		return
	end

	local lines = {}

	for line in vim.gsplit(src, "\n") do
		if line:len() > 0 then
			if use_qf_list then
				line = { text = line:gsub("\t", "  ") }
			end

			table.insert(lines, line)
		end
	end

	if use_qf_list then
		vim.fn.setqflist({}, "r", { items = lines, title = "Messages" })
		vim.cmd.copen()
	else
		vim.cmd.new()
		vim.cmd.resize(-10)
		vim.bo.buftype = "nofile"
		vim.bo.bufhidden = "hide"
		vim.bo.buflisted = false
		vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	end

	vim.cmd.norm("G")

	return input
end

usercmd("Messages", function(opts)
	vim.cmd("redir => g:messages | silent! messages | redir END")
	Print(vim.g.messages, opts.args == "qf")
	vim.g.messages = nil
end, { nargs = "?" })
