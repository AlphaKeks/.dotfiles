vim.bo.tabstop = 8
vim.bo.softtabstop = 8
vim.bo.shiftwidth = 8

local eval_sql = function(connect)
	local sql = nvim_buf_get_lines(0, 0, -1, false)

	System(connect, function(result)
		if result.code ~= 0 then
			return vim.error("Failed to execute SQL: %s", vim.inspect(result))
		end

		local output = {}

		for line in vim.gsplit(result.stdout, "\n", { trimempty = true }) do
			table.insert(output, { text = line })
		end

		table.remove(output, 1)

		for line in vim.gsplit(result.stderr, "\n", { trimempty = true }) do
			table.insert(output, { text = line })
		end

		setqflist({}, "r", { title = "SQL Output", items = output })
		copen()
		wincmd("p")
	end, {
		cmd = {
			stdin = sql,
		},
	})
end

usercmd("SQLConnect", function(cmd)
	autocmd("BufWritePost", {
		group = augroup("sql-on-save-" .. tostring(nvim_get_current_buf())),
		callback = function()
			eval_sql(cmd.fargs)
		end,
	})
end, {
	nargs = "+",
})
