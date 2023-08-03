local files = {
	".eslintrc",
	".eslintrc.js",
	".eslintrc.cjs",
	".eslintrc.yaml",
	".eslintrc.yml",
	".eslintrc.json",
	"eslint.config.js",
}

local severities = {
	[1] = vim.diagnostic.severity.WARN,
	[2] = vim.diagnostic.severity.ERROR,
}

local namespace = create_namespace("eslint-stuff")

local function lint_on_save()
	autocmd("BufWritePost", {
		desc = "Run eslint after saving",
		group = augroup("eslint-on-save"),
		buffer = bufnr(),
		callback = function()
			if not vim.fs.find(files, { upward = true })[1] then
				return
			end

			run_shell({ "eslint_d", "--format", "json", expand("%") }, function(result)
				local output = vim.json.decode(result.stdout)
				local messages = output and output[1] and output[1].messages or {}
				local diagnostics = {}

				for _, message in ipairs(messages) do
					table.insert(diagnostics, {
						bufnr = 0,
						lnum = (message.line or 1) - 1,
						end_lnum = (message.endLine or 1) - 1,
						col = (message.column or 1) - 1,
						end_col = (message.endColumn or 1) - 1,
						severity = severities[message.severity],
						message = message.message,
						source = "ESLint",
					})
				end

				vim.diagnostic.set(namespace, 0, diagnostics)
				vim.diagnostic.setqflist({
					namespace = namespace,
					open = false,
					title = "ESLint",
				})
			end, { ignore_errors = true })
		end,
	})

	autocmd("VimLeave", {
		desc = "Stop eslint_d before quitting",
		group = augroup("kill-eslint-daemon"),
		callback = function()
			run_shell({ "eslint_d", "stop" })
		end,
	})
end

return { setup = lint_on_save }
