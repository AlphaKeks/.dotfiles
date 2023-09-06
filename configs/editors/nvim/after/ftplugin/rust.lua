local lsp = require("alphakeks.lsp")
local rust_analyzer = { "rustup", "run", "stable", "rust-analyzer" }
local rust_toolchain = vim.fs.find({ "rust-toolchain" }, { upward = true })

if rust_toolchain[1] then
	rust_analyzer[3] = readfile(rust_toolchain[1])
end

local rustfmt_opts = {}
local rustfmt = vim.fs.find({ "rustfmt.toml", ".rustfmt.toml" }, { upward = true })

if vim.tbl_isempty(rustfmt) then
	rustfmt_opts.overrideCommand = { "rustfmt", "+nightly", "--emit", "stdout" }
else
	for _, line in ipairs(readfile(rustfmt[1])) do
		if line == "unstable_features = true" then
			rustfmt_opts.overrideCommand = { "rustfmt", "+nightly", "--emit", "stdout" }
		end
	end
end

vim.lsp.start({
	name = "rust-analyzer",
	cmd = rust_analyzer,
	root_dir = lsp.find_root({ "Cargo.toml" }),
	capabilities = lsp.capabilities,
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
					enable = true,
					useParameterNames = true,
				},
			},

			rustfmt = rustfmt_opts,
		},
	},

	---@param client lsp.Client
	---@param buffer integer
	on_attach = function(client, buffer)
		command("CargoReload", function()
			client.request("rust-analyzer/reloadWorkspace", nil, function(error)
				if error then
					return vim.error("Failed to reload cargo workspace: %s", vim.inspect(error))
				end

				vim.info("Reloaded cargo workspace.")
			end, buffer)
		end, { buffer = true })
	end,
})
