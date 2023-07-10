-- https://GitHub.com/AlphaKeks/.dotfiles

source("~/.vim/after/ftplugin/typescript.vim")

local lsp = require("alphakeks.lsp")

vim.lsp.start(lsp.configs.typescript())

-- Prettier
autocmd("BufWritePre", {
	group = augroup("prettier-format-on-save"),
	callback = function()
		local prettier = { "npx", "prettier", "--write" }
		local prettier_files = {
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

		if not vim.fs.find(prettier_files, { upward = true })[1] then
			table.insert(prettier, "--config")
			table.insert(
				prettier,
				os.getenv "HOME" .. "/.dotfiles/configs/tools/prettier/prettier.config.js"
			)
		end

		table.insert(prettier, expand("%"))

		vim.system(prettier, {}, function(result)
			if result.code ~= 0 then
				vim.error(result.stderr)
			end

			vim.schedule(function()
				vim.cmd("e!")
			end)
		end)
	end,
})

local group = augroup("typescript-jazz")
local namespace = create_namespace("typescript-jazz")

local function process_eslint(message)
	return {
		bufnr = 0,
		lnum = message.line - 1,
		end_lnum = message.endLine - 1,
		col = message.column - 1,
		end_col = message.endColumn - 1,
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
		vim.diagnostic.setqflist({
			namespace = namespace,
			open = false,
			title = qflist_title or "",
		})
	end)
end

-- ESLint
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
			local eslint = { "npx", "eslint", "--format", "json", expand("%") }

			vim.system(eslint, opts, function(result)
				set_diagnostics(result, process_eslint, "ESLint")
			end)
		end
	end,
})
