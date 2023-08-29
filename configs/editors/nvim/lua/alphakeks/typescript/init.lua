local lsp = require("alphakeks.lsp")

local tsserver = function()
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

return {
	tsserver = tsserver,
	prettier = require("alphakeks.typescript.prettier"),
	eslint = require("alphakeks.typescript.eslint"),
}
