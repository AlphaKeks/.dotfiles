-- https://GitHub.com/AlphaKeks/.dotfiles

local mason_installed, mason = pcall(require, "mason")
if mason_installed then
	mason.setup({})
end

local function setup_keymaps(buffer)
	local function bmap(modes, lhs, rhs)
		vim.keymap.set(modes, lhs, rhs, { buffer = buffer })
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

local function format_on_save(pattern)
	autocmd("BufWritePre", {
		group = augroup("lsp-format-on-save", { clear = true }),
		callback = function(args)
			if vim.endswith(args.match, pattern) then
				vim.lsp.buf.format()
			end
		end,
	})
end

local inlay_hints_group = augroup("inlay-hints-toggle", { clear = true })

local function inlay_hints_on()
	pcall(vim.lsp.buf.inlay_hint, 0, true)
end

local function inlay_hints_off()
	pcall(vim.lsp.buf.inlay_hint, 0, false)
end

local function inlay_hints_toggle()
	autocmd("InsertLeave", {
		group = inlay_hints_group,
		callback = inlay_hints_on,
	})
	
	autocmd("InsertEnter", {
		group = inlay_hints_group,
		callback = inlay_hints_off,
	})
end

autocmd("LspAttach", {
	group = augroup("lsp-default-attach", { clear = true }),
	callback = function(args)
		-- enable completion via <C-x><C-o>
		vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
		setup_keymaps(args.buf)

		usercmd("Format", function()
			vim.lsp.buf.format()
		end)

		-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
		--	 vim.lsp.handlers.hover, { border = "single" }
		-- )
		--
		-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		--	 vim.lsp.handlers.signature_help, { border = "single" }
		-- )
	end,
})

vim.lsp.setup("rust_analyzer", {
	on_attach = function(client, buffer)
		-- client.server_capabilities.semanticTokensProvider = nil
		format_on_save(".rs")
		inlay_hints_on()
		inlay_hints_toggle()
	end,
	cmd = { "/home/alphakeks/.local/bin/rust-analyzer/release/rust-analyzer" },
	settings = {
		["rust-analyzer"] = {
			cargo = {
				features = "all",
			},

			checkOnSave = true,

			check = {
				command = "clippy",
				allTargets = true,
				features = "all",
				invocationLocation = "workspace",
				extraArgs = { "--tests" },
			},
		},
	},
})

vim.lsp.setup("tsserver")
vim.lsp.setup("taplo")
vim.lsp.setup("nil_ls")

