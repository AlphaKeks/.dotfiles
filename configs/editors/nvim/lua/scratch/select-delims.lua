local delimiters = {
	["<"] = "t",
	[">"] = "t",
	["("] = "b",
	[")"] = "b",
}

local function select_inside()
	local line = getline(line("."))
	local pos = getcursorcharpos()[3]
	local left
	local right

	for i = 1, #line do
		local char = line:sub(i, i)
		if vim.tbl_contains(delimiters, char) then
			if left then
				right = i
				break
			else
				left = i
			end
		end
	end

	local idx = math.min(math.abs(left - pos), math.abs(#line - right))
	vim.print(idx)
	local char = line:sub(idx, idx)
	local key = delimiters[char]

	if not key then
		return
	end

	vim.print(key)
end

--- <html> hello world </html>

keymap("n", "<Leader>vi", select_inside)
