-- https://GitHub.com/AlphaKeks/.dotfiles

source("~/.vim/after/ftplugin/rust.vim")

local lsp = require("alphakeks.lsp")
local capabilities = lsp.capabilities

capabilities.experimental = {
	serverStatusNotification = true,
}

local custom_ra_path = os.getenv("HOME") .. "/.local/bin/rust-analyzer/release/rust-analyzer"
local rustfmt_file = vim.fs.find({ "rustfmt.toml", ".rustfmt.toml" }, { upward = true })[1]
local rustfmt = {}

if rustfmt_file then
	local contents = readfile(rustfmt_file)

	for _, line in ipairs(contents) do
		if line == "unstable_features = true" then
			rustfmt.overrideCommand = { "rustfmt", "+nightly", "--emit", "stdout" }
		end
	end
end

vim.lsp.start({
	name = "rust-analyzer",
	cmd = { custom_ra_path },
	capabilities = capabilities,
	root_dir = vim.fs.dirname(
		vim.fs.find({ "Cargo.toml" }, { upward = true })[1]
	),

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

			inlayHints = {
				expressionAdjustmentHints = {
					enable = true,
					mode = "prefix",
				},

				lifetimeElisionHints = {
					enable = true,
					useParameterNames = true,
				},
			},

			rustfmt = rustfmt,
		},
	},

	on_attach = function(client, bufnr)
		-- vim.print(client.server_capabilities)

		usercmd("CargoReload", function()
			vim.lsp.buf_request(bufnr, "rust-analyzer/reloadWorkspace", nil, function(err)
				if err then
					vim.error("Error reloading workspace: " .. vim.inspect(err))
				else
					vim.info("Cargo workspace reloaded.")
				end
			end)
		end)
	end,
})
