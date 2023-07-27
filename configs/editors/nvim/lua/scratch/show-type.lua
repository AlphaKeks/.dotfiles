local bufnr = vim.api.nvim_get_current_buf()
local method = "textDocument/hover"
local params = vim.lsp.util.make_position_params()

vim.lsp.buf_request_all(bufnr, method, params, function(result, err)
	if err then
		vim.error("Hover request failed: %s", vim.inspect(err))
		return
	end

	-- TODO: I hate this.
	if not (result
				and result[1]
				and result[1].result
				and result[1].result.contents
				and result[1].result.contents.value) then
		return
	end

	local lines = vim.gsplit(result[1].result.contents.value, "\n")
	lines()
	lines()

	print(lines())
end)
