local snippet = require("luasnip").s
local format = require("luasnip.extras.fmt").fmt
local insert = require("luasnip").insert_node
local choice = require("luasnip").choice_node
local fun = require("luasnip").function_node

return {
	snippet("__snips", format([[
		local snippet = require("luasnip").s
		local format = require("luasnip.extras.fmt").fmt
		local insert = require("luasnip").insert_node
		local choice = require("luasnip").choice_node
		local fun = require("luasnip").function_node

		return {{
			{}
		}}
	]], {
		insert(0, ""),
	})),
}
