require("alphakeks.keymaps")

-- {{{ Lazy

local lazy_path = stdpath("data") .. "/lazy/lazy.nvim"
local lazy_setup = function()
	vim.opt.runtimepath:prepend(lazy_path)

	require("lazy").setup("plugins", {
		defaults = {
			lazy = false,
		},

		install = {
			missing = true,
			colorscheme = { "dawn", "habamax" },
		},

		ui = {
			wrap = true,
			border = "single",
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

local lazy_installed = vim.uv.fs_stat(lazy_path)

if lazy_installed then
	lazy_setup()
else
	local command = {
		"git", "clone", "--branch=stable",
		"https://github.com/folke/lazy.nvim",
		lazy_path,
	}

	System(command, function()
		vim.info("Successfully installed lazy.nvim")
		lazy_setup()
	end)
end

-- }}}

-- {{{ Quickfix List

_G.SendToQf = function(item, custom_title)
	if not item then
		return item
	end

	local is_string = type(item) == "string"
	local is_table = type(item) == "table"

	if not (is_string or is_table) then
		vim.error("`%s` is not a valid argument type.", type(item))
		return item
	end

	if is_table and vim.tbl_count(item) == 0 then
		return item
	end

	if is_string and #item == 0 then
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

	vim.schedule(function()
		setqflist({}, "r", { items = lines, title = custom_title or "" })
		copen()
		norm("G")
		wincmd("k")
	end)

	return item
end

-- }}}

-- {{{ Git

_G.Git = function(args)
	if #args == 0 then
		args = { "status" }
	end

	local command = vim.tbl_merge({ "git" }, args)

	System(command, function(result)
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
end

-- }}}

-- {{{ Reload

_G.ReloadPlugin = function(plugin)
	local ok, spec = pcall(Require, "plugins." .. plugin)

	if ok then
		spec.config()
		vim.info("Reloaded `%s`.", plugin)
	else
		vim.error("`%s` is not a valid plugin.", plugin)
	end
end

-- }}}

-- {{{ Run on save

_G.RunOnSave = function(code)
	autocmd("BufWritePost", {
		group = augroup("run-on-save", { clear = false }),
		buffer = bufnr(),
		callback = function()
			luaeval(code)
		end,
	})
end

-- }}}

-- vim: foldmethod=marker foldlevel=0
