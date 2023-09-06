local lsp = require("alphakeks.lsp")

local setup = function()
	vim.lsp.start({
		name = "tsserver",
		cmd = { "typescript-language-server", "--stdio" },
		root_dir = lsp.find_root({ "package.json" }),
		capabilities = lsp.capabilities,
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
	})
end

return {
	setup = setup,
}
