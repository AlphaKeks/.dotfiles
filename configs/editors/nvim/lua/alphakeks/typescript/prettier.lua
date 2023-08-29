local files = {
	".prettierrc",
	".prettierrc.json",
	".prettierrc.yml",
	".prettierrc.yaml",
	".prettierrc.json5",
	".prettierrc.js",
	".prettierrc.cjs",
	".prettierrc.toml",
	"prettier.config.js",
	"prettier.config.cjs",
}

local prettier_augroup = augroup("prettier-on-save")

local run = function()
	local command = { "prettierd", expand("%") }

	System(command, function(result)
		local lines = {}

		for line in vim.gsplit(result.stdout, "\n") do
			table.insert(lines, line)
		end

		nvim_buf_set_lines(0, 0, -1, false, lines)
	end, {
		cmd = {
			stdin = nvim_buf_get_lines(0, 0, -1, false),
			env = {
				PRETTIERD_DEFAULT_CONFIG = vim.env.DOTFILES .. "/configs/tools/prettier/prettier.config.js",
			},
		}
	}, { ignore_errors = true })
end

local restart = function()
	System({ "prettierd", "restart" })
end

local format_on_save = function()
	autocmd("BufWritePost", {
		desc = "Run prettier after saving",
		group = prettier_augroup,
		buffer = bufnr(),
		callback = function()
			if not vim.tbl_contains(files, expand("%:p:t")) then
				run()
			end
		end,
	})

	autocmd("VimLeave", {
		desc = "Stop prettierd before quitting",
		group = augroup("kill-prettier-daemon"),
		callback = function()
			System({ "prettierd", "stop" })
		end,
	})
end

local detect_changes = function()
	autocmd("BufWritePost", {
		pattern = files,
		group = prettier_augroup,
		callback = restart,
	})
end

local setup = function()
	buf_usercmd(bufnr(), "Prettier", run)
	buf_usercmd(bufnr(), "PrettierRestart", restart)
	format_on_save()
	detect_changes()
end

return { run = run, restart = restart, setup = setup }
