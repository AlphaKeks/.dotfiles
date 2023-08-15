return {
	"hrsh7th/nvim-cmp",

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

		cmp.setup({
			preselect = cmp.PreselectMode.None,
			mapping = cmp.mapping.preset.insert({
				["<cr>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
				["<Right>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-d>"] = cmp.mapping.scroll_docs(4),
				["<C-u>"] = cmp.mapping.scroll_docs(-4),
				["<C-n>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end),
				["<C-p>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end),
				["<C-j>"] = cmp.mapping(function(fallback)
					if luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<C-k>"] = cmp.mapping(function(fallback)
					if luasnip.jumpable(-1) then
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
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "nvim_lsp" },
				{ name = "buffer" },
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

		keymap("i", "<C-n>", cmp.complete)
		keymap("i", "<C-p>", cmp.complete)

		-- Fix luasnip sometimes hijacking <Tab> for longer than it's supposed to
		autocmd("InsertLeave", {
			group = augroup("luasnip-clean-snippet-nodes"),
			callback = function()
				luasnip.session.current_nodes[bufnr()] = nil
			end,
		})
	end,
}
