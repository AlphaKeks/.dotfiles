local snippet = require("luasnip").s
local format = require("luasnip.extras.fmt").fmt
local insert = require("luasnip").insert_node
local choice = require("luasnip").choice_node
local fun = require("luasnip").function_node

return {
	snippet("__datetime", fun(function()
		return os.date("%Y-%m-%d %H:%M:%S")
	end)),
}
