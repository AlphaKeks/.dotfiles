local M = { data = {} }

function M:new(tbl)
	self.data = tbl
	return self
end

function M:next()
	return table.remove(self.data, 1)
end

function M:count()
	return #self.data
end

function M:last()
	return table.remove(self.data, #self)
end

function M:nth(n)
	return table.remove(self.data, n)
end

function M:map(f)
	local new = {}

	for _, item in ipairs(self.data) do
		table.insert(new, f(item))
	end

	self.data = new

	return self
end

function M:for_each(f)
	for _, item in ipairs(self.data) do
		f(item)
	end
end

function M:filter(predicate)
	local new = {}

	for _, item in ipairs(self.data) do
		if predicate(item) then
			table.insert(new, item)
		end
	end

	self.data = new
	return self
end

function M:filter_map(f)
	local new = {}

	for _, item in ipairs(self.data) do
		local res = f(item)
		if res then
			table.insert(new, res)
		end
	end

	self.data = new
	return self
end

function M:collect()
	return self.data
end

function M:fold(initial, f)
	for _, item in ipairs(self.data) do
		initial = f(initial, item)
	end

	return initial
end

function M:all(predicate)
	for _, item in ipairs(self.data) do
		if not predicate(item) then
			return false
		end
	end

	return true
end

function M:any(predicate)
	for _, item in ipairs(self.data) do
		if predicate(item) then
			return true
		end
	end

	return false
end

function M:position(predicate)
	for i, item in ipairs(self.data) do
		if predicate(item) then
			return i
		end
	end

	return nil
end

return vim.deepcopy(M)
