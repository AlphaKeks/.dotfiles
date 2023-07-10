-- https://GitHub.com/AlphaKeks/.dotfiles

vim.cmd.source("~/.vim/after/ftplugin/typescript.vim")

local lsp = require("alphakeks.lsp")

vim.lsp.start(lsp.configs.typescript())

local group = augroup("typescript-jazz")
local namespace = vim.api.nvim_create_namespace("typescript-jazz")

local function process_eslint(message)
	return {
		bufnr = 0,
		lnum = message.line - 1,
		end_lnum = message.endLine - 1,
		col = message.column,
		end_col = message.endColumn,
		severity = message.severity,
		message = message.message,
		source = "eslint",
	}
end

local function set_diagnostics(result, process_message, qflist_title)
	local errors = vim.json.decode(result.stdout)
	local messages = errors and errors[1] and errors[1].messages or {}
	local diagnostics = {}

	for _, message in ipairs(messages) do
		table.insert(diagnostics, process_message(message))
	end

	vim.schedule(function()
		vim.diagnostic.set(namespace, 0, diagnostics)
		vim.diagnostic.setqflist({ namespace = namespace, open = false, title = qflist_title or "" })
	end)
end

autocmd("BufWritePost", {
	group = group,
	callback = function()
		local opts = { text = true }
		local eslint_files = {
			".eslintrc",
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.yaml",
			".eslintrc.yml",
			".eslintrc.json",
			"eslint.config.js",
		}

		if vim.fs.find(eslint_files, { upward = true })[1] then
			local eslint = { "npx", "eslint", "--format", "json", vim.fn.expand("%") }

			vim.system(eslint, opts, function(result)
				set_diagnostics(result, process_eslint, "ESLint")
			end)
		end
	end,
})
