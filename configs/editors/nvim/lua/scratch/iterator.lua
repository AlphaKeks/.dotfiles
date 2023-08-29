local M = { data = {} }

M.new(self, tbl)
	self.data = tbl
	return self
end

M.next(self)
	return table.remove(self.data, 1)
end

M.count(self)
	return #self.data
end

M.last(self)
	return table.remove(self.data, #self)
end

M.nth(self, n)
	return table.remove(self.data, n)
end

M.map(self, f)
	local new = {}

	for _, item in ipairs(self.data) do
		table.insert(new, f(item))
	end

	self.data = new

	return self
end

M.for_each(self, f)
	for _, item in ipairs(self.data) do
		f(item)
	end
end

M.filter(self, predicate)
	local new = {}

	for _, item in ipairs(self.data) do
		if predicate(item) then
			table.insert(new, item)
		end
	end

	self.data = new
	return self
end

M.filter_map(self, f)
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

M.collect(self)
	return self.data
end

M.fold(self, initial, f)
	for _, item in ipairs(self.data) do
		initial = f(initial, item)
	end

	return initial
end

M.all(self, predicate)
	for _, item in ipairs(self.data) do
		if not predicate(item) then
			return false
		end
	end

	return true
end

M.any(self, predicate)
	for _, item in ipairs(self.data) do
		if predicate(item) then
			return true
		end
	end

	return false
end

M.position(self, predicate)
	for i, item in ipairs(self.data) do
		if predicate(item) then
			return i
		end
	end

	return nil
end

return vim.deepcopy(M)
