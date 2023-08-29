return {
	"hrsh7th/nvim-cmp",

	enabled = false,

	event = "InsertEnter",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
	},

	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		require("luasnip.loaders.from_lua").lazy_load({ paths = stdpath("config") .. "/snippets" })
		-- require("alphakeks.kz_maps_cmp")

		cmp.setup({
			preselect = cmp.PreselectMode.None,
			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),

				["<cr>"] = cmp.mapping.confirm({
					select = true,
					behavior = cmp.ConfirmBehavior.Insert
				}),

				["<Right>"] = cmp.mapping.confirm({
					select = true,
					behavior = cmp.ConfirmBehavior.Insert
				}),

				["<C-j>"] = cmp.mapping.scroll_docs(4),
				["<C-k>"] = cmp.mapping.scroll_docs(-4),

				["<C-l>"] = cmp.mapping(function(fallback)
					if luasnip.locally_jumpable(1) then
						luasnip.jump(1)
					else
						fallback()
					end
				end, { "i", "s" }),

				["<C-h>"] = cmp.mapping(function(fallback)
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),

			completion = {
				autocomplete = false,
			},

			sources = {
				{ name = "path" },
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{
					name = "buffer",
					option = {
						get_bufnrs = function()
							return vim.tbl_map(function(win)
								return nvim_win_get_buf(win)
							end, nvim_list_wins())
						end
					},
				}
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

		keymap({ "i", "s" }, "<ESC>", function()
			luasnip.session.current_nodes[bufnr()] = nil
			return "<ESC>"
		end, {
			expr = true,
			desc = "Cleanup luasnip nodes when entering normal mode",
		})
	end,
}
