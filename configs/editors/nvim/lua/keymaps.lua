local function a_num(num)
	local expr = num .. "k"
	local op = vim.v.operator

	if op == "d" then
		expr = expr .. string.format("d%sj", num - 1)
	elseif op == "c" then
		expr = expr .. string.format("<esc>c%sj", num)
	elseif op == "y" then
		expr = expr .. string.format("y%sj%sj", num * 2, num)
	elseif op == ">" or op == "<" then
		expr = expr .. string.format("%sj", num + 1) .. op .. string.format("%sjk", num - 1)
	else
		expr = expr .. op .. string.format("%sj", num)
	end

	return expr
end

for i = 1, 9 do
	local a_motion = string.format("a%s", i)
	local i_motion = string.format("i%s", i)

	keymap("o", a_motion, function()
		return a_num(i)
	end, { expr = true })

	keymap("v", a_motion, function()
		local selection_line = line("v")
		local current_line = line(".")

		if selection_line > current_line then
			return string.format("%sko%sj", i, i)
		else
			return string.format("%sjo%sk", i, i)
		end
	end, { expr = true })

	keymap("v", i_motion, function()
		local selection_line = line("v")
		local current_line = line(".")

		if selection_line < current_line then
			return string.format("%sko%sj", i, i)
		else
			return string.format("%sjo%sk", i, i)
		end
	end, { expr = true })
end
