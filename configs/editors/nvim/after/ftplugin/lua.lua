source("~/.vim/after/ftplugin/lua.vim")

local lsp = require("alphakeks.lsp")

vim.lsp.start({
	name = "lua_ls",
	cmd = { "lua-language-server" },
	root_dir = lsp.find_root({ "lua" }, true),
	capabilities = lsp.capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},

			workspace = {
				library = {
					vim.env.VIMRUNTIME,
					stdpath("config") .. "/lua",
				},
			},

			format = {
				enable = true,
				defaultConfig = {
					indent_style = "tab",
					tab_width = "2",
					quote_style = "double",
					call_arg_parentheses = "keep",
					max_line_length = "120",
					end_of_line = "LF",
					space_around_table_field_list = "true",
					align_call_args = "false",
					align_function_params = "false",
					align_continuous_assign_statement = "false",
					align_continuous_rect_table_field = "false",
					align_if_branch = "false",
					align_array_table = "false",
				},
			},

			diagnostics = {
				globals = { "vim", "awesome" },
				disable = { "lowercase-global" },
			},

			telemetry = {
				enable = false,
			},
		},
	},

	on_attach = function(client)
		lsp.disable_semantic_highlights(client)
	end,
})
