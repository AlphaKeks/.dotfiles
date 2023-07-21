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
end)

usercmd("LG", function()
	vim.cmd.Term()
	nvim_input("lg<CR>")
end)

function Reload(...)
	local plenary_installed, plenary = pcall(require, "plenary.reload")

	if plenary_installed then
		plenary.reload_module(...)
	end

	return require(...)
end

function SendToQf(item)
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

	setqflist({}, "r", { items = lines, title = "Messages" })
	copen()
	vim.keymap.set("n", "<CR>", "<CR>0w\"+y$", { buffer = true })
	norm("G")

	return item
end

usercmd("Messages", function()
	vim.cmd("redir => g:messages | silent messages | redir END")
	SendToQf(vim.g.messages)
end)

function LuaRepl()
	local function callback(text)
		local result = eval(text or "nil")
		append(line("$") - 1, result or "")
	end

	new()
	vim.bo.buftype = "prompt"
	prompt_setcallback(bufnr(), callback)
	keymap("n", "<ESC>", "<CMD>bw!<CR>", { buffer = true, silent = true })
	startinsert()
end

usercmd("Repl", LuaRepl)

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

	vim.system(command, { text = true }, vim.schedule_wrap(function(result)
		if result.code ~= 0 then
			vim.error("Failed to install lazy.nvim: %s", vim.inspect(result))
			return
		end

		vim.info("Successfully installed lazy.nvim")
		lazy_setup()
	end))
end
