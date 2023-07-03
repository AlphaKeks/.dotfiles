-- https://GitHub.com/AlphaKeks/.dotfiles

local M = {
	augroups = {
		global = augroup("lsp-on-attach"),
		format_on_save = augroup("lsp-format-on-save"),
		inlay_hints = augroup("lsp-inlay-hints"),
	},

	configs = {},
}

M.keymaps = function(bufnr)
	local function bmap(modes, lhs, rhs)
		vim.keymap.set(modes, lhs, rhs, { buffer = bufnr })
	end

	bmap("n", "gd", vim.lsp.buf.definition)
	bmap("n", "gD", vim.lsp.buf.type_definition)
	bmap("n", "<Leader><Leader>", vim.lsp.buf.hover)
	bmap("n", "ga", vim.lsp.buf.code_action)
	bmap("n", "gr", vim.lsp.buf.rename)
	bmap("n", "gR", vim.lsp.buf.references)
	bmap("n", "gi", vim.lsp.buf.implementation)
	bmap("i", "<C-h>", vim.lsp.buf.signature_help)
end

M.format_on_save = function(bufnr)
	autocmd("BufWritePre", {
		group = M.augroups.format_on_save,
		buffer = bufnr,
		callback = function()
			if not pcall(vim.lsp.buf.format) then
				vim.notify("Failed to format buffer.", vim.log.levels.ERROR)
			end
		end,
	})
end

M.inlay_hints = function(bufnr)
	if not pcall(vim.lsp.inlay_hint, bufnr, true) then
		vim.notify("Failed to activate inlay hints.", vim.log.levels.ERROR)
	end

	autocmd({ "InsertEnter", "InsertLeave" }, {
		group = M.augroups.inlay_hints,
		buffer = bufnr,
		callback = function()
			if not pcall(vim.lsp.inlay_hint, bufnr) then
				vim.notify("Failed to toggle inlay hints.", vim.log.levels.ERROR)
			end
		end,
	})
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

local cmp_installed, cmp_capabilities = pcall(require, "cmp_nvim_lsp")

if cmp_installed then
	M.capabilities = vim.tbl_deep_extend(
		"force",
		M.capabilities,
		cmp_capabilities.default_capabilities()
	)
end

M.configs.rust = function()
	local capabilities = M.capabilities
	capabilities.experimental = {
		serverStatusNotification = true,
	}

	local custom_ra_path = os.getenv("HOME") .. "/.local/bin/rust-analyzer/release/rust-analyzer"

	return {
		name = "rust-analyzer",

		cmd = { custom_ra_path },

		capabilities = capabilities,

		settings = {
			["rust-analyzer"] = {
				cargo = {
					features = "all",

					check = {
						command = "clippy",
						extraArgs = { "--tests" },
						features = "all",
					},
				},

				imports = {
					granularity = {
						enforce = true,
						group = "one",
					},
				},

				-- Pretty cool but annoying
				-- inlayHints = {
				-- 	expressionAdjustmentHints = {
				-- 		enable = true,
				-- 		mode = "prefix",
				-- 	},
				--
				-- 	lifetimeElisionHints = {
				-- 		enable = true,
				-- 		useParameterNames = true,
				-- 	},
				-- },

				rustfmt = {
					overrideCommand = { "rustfmt", "+nightly", "--emit", "stdout" },
				},
			},
		},

		trace = "verbose",

		root_dir = vim.fs.dirname(
			vim.fs.find({ "Cargo.toml" }, { upward = true })[1]
		),

		on_attach = function(client, bufnr)
			usercmd("CargoReload", function()
				vim.lsp.buf_request(bufnr, "rust-analyzer/reloadWorkspace", nil, function(err)
					if err then
						vim.notify("error reloading workspace: " .. vim.inspect(err), vim.log.levels.ERROR)
					end

					vim.notify("Cargo workspace reloaded.", vim.log.levels.INFO)
				end)
			end)
		end,
	}
end

M.configs.toml = function()
	return {
		name = "taplo",

		cmd = { "taplo", "lsp", "stdio" },

		capabilities = M.capabilities,

		root_dir = vim.fs.dirname(
			vim.fs.find({ "*.toml" }, { upward = true })[1]
		),
	}
end

M.configs.typescript = function()
	return {
		name = "tsserver",

		cmd = { "typescript-language-server", "--stdio" },

		capabilities = M.capabilities,

		root_dir = vim.fs.dirname(
			vim.fs.find({ ".git", "package.json" }, { upward = true })[1]
		),
	}
end

autocmd("LspAttach", {
	group = M.augroups.global,
	callback = function(args)
		M.keymaps(args.buf)

		-- LSP omni-completion
		vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		usercmd("Format", function()
			if not pcall(vim.lsp.buf.format) then
				vim.notify("Failed to format buffer.", vim.log.levels.ERROR)
			end
		end)

		local client = vim.lsp.get_client_by_id(args.data.client_id)
		-- print("LSP capabilities: " .. vim.inspect(client.server_capabilities))

		if client.server_capabilities.documentFormattingProvider then
			M.format_on_save(args.buf)
		end

		if client.server_capabilities.inlayHintProvider ~= nil then
			M.inlay_hints(args.buf)
		end
	end,
})

return M

