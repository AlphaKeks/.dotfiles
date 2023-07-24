autocmd("TextYankPost", {
	desc = "Highlight text after yanking it",
	callback = function()
		vim.highlight.on_yank({
			timeout = 69,
		})
	end,
})

autocmd("TermOpen", {
	command = "setlocal nonumber relativenumber scrolloff=0",
})

usercmd("Term", function()
	tabe()
	term()
	startinsert()
end, { desc = "Opens a terminal in a new tab" })

usercmd("LG", function()
	vim.cmd.Term()
	input("lg<CR>")
	keymap("t", "q", "<CMD>wincmd q<CR>", { buffer = true })
end, { desc = "Opens a terminal with lazygit in a new tab" })

keymap("n", "<Leader>gs", ":LG<CR>")

usercmd("Git", function(cmd)
	local command = vim.tbl_append({ "git" }, cmd.fargs)

	run_shell(command, function(result)
		local stdout = result.stdout
		local stderr = result.stderr
		local stdout_exists = stdout and #stdout > 0
		local stderr_exists = stderr and #stderr > 0
		local messages = ""

		if not (stdout_exists or stderr_exists) then
			return
		end

		if stdout_exists and stderr_exists then
			messages = string.format("STDOUT:\n%s\nSTDERR:\n%s", stdout, stderr)
		elseif stdout_exists then
			messages = stdout
		elseif stderr_exists then
			messages = stderr
		end

		SendToQf(messages, "Git output")
	end)
end, {
	nargs = "+",
	desc = "Run any git command",
})

function Reload(...)
	local plenary_installed, plenary = pcall(require, "plenary.reload")

	if plenary_installed then
		plenary.reload_module(...)
	end

	return require(...)
end

function SendToQf(item, custom_title)
	if not item then
		return item
	end

	local is_string = type(item) == "string"
	local is_table = type(item) == "table"

	if not (is_string or is_table) then
		vim.error("`%s` is not a valid argument type.", type(item))
		return item
	end

	if #item == 0 then
		return item
	end

	local src = ""

	if is_string then
		src = item
	elseif is_table then
		src = vim.inspect(item)
	else
		assert(false, "How did we get here?")
	end

	local lines = {}

	for line in vim.gsplit(src, "\n") do
		if #line > 0 then
			table.insert(lines, {
				text = line:gsub("\t", "  "),
			})
		end
	end

	setqflist({}, "r", { items = lines, title = custom_title or "Messages" })
	copen()
	norm("G")
	wincmd("k")

	return item
end

usercmd("Messages", function()
	vim.cmd("redir => g:messages | silent messages | redir END")
	SendToQf(vim.g.messages)
end, { desc = "Inserts all :messages into the quickfix list and opens it" })

function LuaRepl()
	local function callback(text)
		local result = eval(text)
		append(line("$") - 1, result)
	end

	new()
	vim.bo.buftype = "prompt"
	prompt_setcallback(bufnr(), callback)
	keymap("n", "<ESC>", "<CMD>bw!<CR>", { buffer = true, silent = true })
	startinsert()
end

usercmd("Repl", LuaRepl, { desc = "Opens a Lua REPL" })

-- Plugins
local lazy_path = stdpath("data") .. "/lazy/lazy.nvim"
local lazy_setup = function()
	vim.opt.runtimepath:prepend(lazy_path)

	require("lazy").setup("plugins", {
		defaults = {
			lazy = false,
		},

		install = {
			missing = true,
			colorscheme = { "dawn", "catppuccin", "habamax" },
		},

		ui = {
			wrap = true,
			border = "solid",
		},

		change_detection = {
			notify = false,
		},

		performance = {
			rtp = {
				reset = false,
				disabled_plugins = {
					"netrwPlugin",
				},
			},
		},
	})
end

if vim.uv.fs_stat(lazy_path) then
	lazy_setup()
else
	local command = {
		"git", "clone", "--branch=stable",
		"https://github.com/folke/lazy.nvim",
		lazy_path,
	}

	run_shell(command, function()
		vim.info("Successfully installed lazy.nvim")
		lazy_setup()
	end)
end
