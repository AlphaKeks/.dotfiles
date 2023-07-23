local lsp = require("alphakeks.lsp")

local function tsserver()
	return {
		name = "tsserver",
		cmd = { "typescript-language-server", "--stdio" },
		capabilities = lsp.capabilities,
		root_dir = lsp.find_root({ "package.json" }),
		init_options = {
			hostInfo = "neovim",
			preferences = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
				importModuleSpecifierPreference = "non-relative",
			},
		},
	}
end

local function prettier()
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

	autocmd("BufWritePost", {
		desc = "Run prettier after saving",
		group = augroup("prettier-format-on-save"),
		buffer = bufnr(),
		callback = function()
			local command = { "prettier", "--write" }

			if not vim.fs.find(files, { upward = true })[1] then
				table.insert(command, "--config")
				table.insert(
					command,
					os.getenv("HOME") .. "/.dotfiles/configs/tools/prettier/prettier.config.js"
				)
			end

			table.insert(command, expand("%"))

			run_shell(command, function()
				vim.cmd("e!")
			end)
		end,
	})
end

local function eslint()
	local files = {
		".eslintrc",
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.yaml",
		".eslintrc.yml",
		".eslintrc.json",
		"eslint.config.js",
	}

	local namespace = create_namespace("eslint-stuff")

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
						severity = message.severity,
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
			end)
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

return {
	tsserver = tsserver,
	prettier = prettier,
	eslint = eslint,
}
