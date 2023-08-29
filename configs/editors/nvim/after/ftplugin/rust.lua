source("~/.vim/after/ftplugin/rust.vim")

vim.bo.formatprg = nil

local lsp = require("alphakeks.lsp")
-- local rust_analyzer = vim.env.HOME .. "/.local/bin/rust-analyzer"
local rust_analyzer = { "rustup", "run", "stable", "rust-analyzer" }
local rustfmt = vim.fs.find({ "rustfmt.toml", ".rustfmt.toml" }, { upward = true })
local rustfmt_opts = {}

if not rustfmt[1] then
	rustfmt_opts.overrideCommand = { "rustfmt", "+nightly", "--emit", "stdout" }
else
	local contents = readfile(rustfmt[1])

	for _, line in ipairs(contents) do
		if line == "unstable_features = true" then
			rustfmt_opts.overrideCommand = { "rustfmt", "+nightly", "--emit", "stdout" }
		end
	end
end

vim.lsp.start({
	name = "rust-analyzer",
	cmd = rust_analyzer,
	capabilities = lsp.capabilities,
	root_dir = lsp.find_root({ "Cargo.toml", "rust-project.json" }),
	settings = {
		["rust-analyzer"] = {
			cargo = {
				features = "all",
			},

			checkOnSave = true,
			check = {
				command = "clippy",
				extraArgs = { "--tests" },
				features = "all",
			},

			imports = {
				granularity = {
					enforce = true,
					group = "one",
				},
			},

			inlayHints = {
				expressionAdjustmentHints = {
					enable = false,
					mode = "prefix",
				},

				lifetimeElisionHints = {
					enable = false,
					useParameterNames = true,
				},
			},

			rustfmt = rustfmt_opts,
		},
	},

	on_attach = function(_ --[[ client ]], bufnr)
		-- client.server_capabilities.semanticTokensProvider = nil

		usercmd("CargoReload", function()
			vim.lsp.buf_request(bufnr, "rust-analyzer/reloadWorkspace", nil, function(err)
				if err then
					vim.error("Error reloading workspace: " .. vim.inspect(err))
				else
					vim.info("Cargo workspace reloaded.")
				end
			end)
		end, {
			desc = "Tells rust-analyzer to read Cargo.toml again",
		})
	end,
})
