-- https://GitHub.com/AlphaKeks/.dotfiles

local M = {
	augroups = {
		global = augroup("lsp-on-attach"),
		progress = augroup("lsp-progress"),
		format_on_save = augroup("lsp-format-on-save"),
		inlay_hints = augroup("lsp-inlay-hints"),
	},

	capabilities = vim.lsp.protocol.make_client_capabilities(),

	keymaps = function(bufnr)
		local function bmap(modes, lhs, rhs)
			keymap(modes, lhs, rhs, { buffer = bufnr, silent = true })
		end

		bmap("n", "gd", vim.lsp.buf.definition)
		bmap("n", "gD", vim.lsp.buf.type_definition)
		bmap("n", "<Leader><Leader>", vim.lsp.buf.hover)
		bmap("n", "ga", vim.lsp.buf.code_action)
		bmap("n", "gr", vim.lsp.buf.rename)
		bmap("n", "gR", vim.lsp.buf.references)
		bmap("n", "gi", vim.lsp.buf.implementation)
		bmap("n", "<Leader>gi", function() vim.lsp.inlay_hint(0) end)
		bmap("i", "<C-h>", vim.lsp.buf.signature_help)
	end,
}

M.format_on_save = function(bufnr)
	autocmd("BufWritePre", {
		group = M.augroups.format_on_save,
		buffer = bufnr,
		callback = function()
			if not pcall(vim.lsp.buf.format) then
				vim.error("Failed to format buffer.")
			end
		end,
	})
end

M.inlay_hints = function(bufnr)
	if not pcall(vim.lsp.inlay_hint, bufnr, true) then
		vim.error("Failed to activate inlay hints.")
	end

	-- Toggle inlay hints when entering / leaving insert mode
	-- autocmd({ "InsertEnter", "InsertLeave" }, {
	-- 	group = M.augroups.inlay_hints,
	-- 	buffer = bufnr,
	-- 	callback = function()
	-- 		if not pcall(vim.lsp.inlay_hint, bufnr) then
	-- 			vim.error("Failed to toggle inlay hints.")
	-- 		end
	-- 	end,
	-- })
end

M.highlight_word = function(bufnr)
	autocmd({ "CursorMoved", "CursorMovedI" }, {
		group = M.augroups.global,
		buffer = bufnr,
		callback = function()
			local utils = require("nvim-treesitter.ts_utils")
			local current_node = utils.get_node_at_cursor()

			if not current_node then
				return
			end

			local node_text = vim.treesitter.get_node_text(current_node, bufnr)

			if vim.g.current_node ~= node_text then
				vim.g.current_node = node_text
				vim.lsp.buf.clear_references(bufnr)

				local node_type = vim.treesitter.get_node():type()

				if node_type == "identifier" or node_type == "property_identifier" then
					vim.lsp.buf.document_highlight()
				end
			end
		end,
	})
end

local cmp_installed, cmp_capabilities = pcall(require, "cmp_nvim_lsp")
if cmp_installed then
	M.capabilities = vim.tbl_deep_extend(
		"force",
		M.capabilities,
		cmp_capabilities.default_capabilities()
	)
else
	M.capabilities = vim.tbl_deep_extend(
		"force",
		M.capabilities,
		require("alphakeks.completion").capabilities
	)
end

M.configs = {
	typescript = {
		tsserver = function()
			return {
				name = "tsserver",
				cmd = { "typescript-language-server", "--stdio" },
				capabilities = M.capabilities,
				root_dir = vim.fs.dirname(
					vim.fs.find({ "package.json" }, { upward = true })[1]
				),

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
		end,

		prettier = function()
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
		end,

		eslint = function()
			local group = augroup("typescript-jazz", { clear = false })
			local namespace = create_namespace("typescript-jazz")

			local function process_eslint(message)
				return {
					bufnr = 0,
					lnum = (message.line or 1) - 1,
					end_lnum = (message.endLine or 1) - 1,
					col = (message.column or 1) - 1,
					end_col = (message.endColumn or 1) - 1,
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
		end,
	},
}

autocmd("LspAttach", {
	group = M.augroups.global,
	callback = function(args)
		M.keymaps(args.buf)

		-- LSP omni-completion
		vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		usercmd("Format", function()
			if not pcall(vim.lsp.buf.format) then
				vim.error("Failed to format buffer.")
			end
		end)

		usercmd("LspLog", function(args)
			local args = args.args
			local log_path = os.getenv("HOME") .. "/.local/state/nvim/lsp.log"

			if #args == 0 then
				edit(log_path)
			elseif args == "edit" then
				edit(log_path)
			elseif args == "clean" then
				vim.system({ "echo", "''", ">", log_path })
			else
				vim.error("`" .. args .. "` is not a valid argument.")
			end
		end, {
			nargs = "?",
			complete = function()
				return { "edit", "clean" }
			end,
		})

		usercmd("LspInfo", function()
			local servers = vim.lsp.get_active_clients()
			local list = "Attached LSP Servers:"

			for _, server in ipairs(servers) do
				list = string.format("%s\n • %s (%s)", list, server.name, server.id)
			end

			print(list)
		end)

		local client = vim.lsp.get_client_by_id(args.data.client_id)
		-- print("LSP capabilities: " .. vim.inspect(client.server_capabilities))

		if client.server_capabilities.documentFormattingProvider
				and client.name ~= "tsserver"
		then
			M.format_on_save(args.buf)
		end

		-- if client.server_capabilities.inlayHintProvider then
		-- 	M.inlay_hints(args.buf)
		-- end

		if client.server_capabilities.documentHighlightProvider then
			M.highlight_word(args.buf)
		end
	end,
})

autocmd("LspProgress", {
	group = M.augroups.progress,
	callback = function()
		redrawstatus()
	end,
})

return M
