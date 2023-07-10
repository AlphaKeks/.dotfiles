return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lsp",
		"L3MON4D3/LuaSnip",
	},

	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		cmp.setup({
			preselect = cmp.PreselectMode.None,
			mapping = cmp.mapping.preset.insert({
				["<cr>"] = cmp.mapping.confirm({ select = true }),
				["<Right>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-j>"] = cmp.mapping.scroll_docs(4),
				["<C-k>"] = cmp.mapping.scroll_docs(-4),
				["<C-n>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end),
				["<C-p>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end),
			}),

			sources = {
				{ name = "nvim_lsp" },
				{ name = "path" },
			},

			formatting = {
				expandable_indicator = false,
				format = function(_, item)
					item.menu = ""
					return item
				end,
			},

			experimental = {
				ghost_text = "Comment",
			},

			views = {
				entries = "native",
			},

			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
		})

		-- Fix luasnip sometimes hijacking <Tab> for longer than it's supposed to
		autocmd("InsertLeave", {
			callback = function()
				local current_buf = vim.api.nvim_get_current_buf()
				luasnip.session.current_nodes[current_buf] = nil
			end,
		})
	end,
}
