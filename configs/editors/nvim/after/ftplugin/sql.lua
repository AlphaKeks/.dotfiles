local augroup = augroup("alphakeks-sql")

local eval_sql = function(connect)
	System(connect, function(result)
		if result.code ~= 0 then
			return vim.error("Failed to execute SQL: %s", vim.inspect(result))
		end

		local items = vim.tbl_map(function(line)
			return { text = line }
		end, vim.split(result.stdout, "\n", { trimempty = true }))

		table.remove(items, 1)

		for line in vim.gsplit(result.stderr, "\n", { trimempty = true }) do
			table.insert(items, { text = line })
		end

		setqflist({}, "r", { title = "SQL Output", items = items })
		copen()
		nvim_input("G<CR>")
	end, { stdin = nvim_buf_get_lines(0, 0, -1, false) })
end

command("SQLConnect", function(cmd)
	autocmd("BufWritePost", {
		group = augroup,
		callback = function()
			eval_sql(cmd.fargs)
		end,
	})
end, {
	buffer = true,
	nargs = "+",
})
