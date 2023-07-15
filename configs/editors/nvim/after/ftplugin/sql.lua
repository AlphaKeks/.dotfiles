vim.bo.tabstop = 8
vim.bo.softtabstop = 8
vim.bo.shiftwidth = 8

autocmd("BufWritePost", {
	desc = "Format SQL after saving",
	group = augroup("sql-format-on-save"),
	buffer = bufnr(),
	callback = function()
		local command = {
			"pg_format",
			"--inplace",
			"--tabs",
			"--type-case", "2",
			"--function-case", "2",
			"--wrap-limit", "100",
			expand("%")
		}

		local opts = { text = true }

		vim.system(command, opts, vim.schedule_wrap(function(result)
			if result.code ~= 0 then
				vim.error("Failed to format SQL: %s", vim.inspect(result))
				return
			end

			vim.cmd("e!")
		end))
	end,
})
