local file_patterns = {
	".eslintrc",
	".eslintrc.js",
	".eslintrc.cjs",
	".eslintrc.yaml",
	".eslintrc.yml",
	".eslintrc.json",
	"eslint.config.js",
}

local namespace = nvim_create_namespace("alphakeks-eslint")
local augroup = augroup("alphakeks-eslint")
local severities = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR }

local execute = function(buffer)
	buffer = if_nil(buffer, nvim_get_current_buf())

	if vim.tbl_isempty(vim.fs.find(file_patterns, { upward = true })) then
		return
	end

	System("eslint_d --format json " .. expand("%"), function(result)
		local output = vim.json.decode(result.stdout)

		if (not output)
				or (not output[1])
				or (not output[1].messages)
		then
			return
		end

		local diagnostics = vim.tbl_map(function(message)
			return {
				bufnr = buffer,
				lnum = if_nil(message.line, 0) - 1,
				col = if_nil(message.column, 0),
				severity = severities[message.severity],
				message = message.message,
				source = "ESLint",
			}
		end, output[1].messages)

		vim.diagnostic.set(namespace, buffer, diagnostics)
		vim.diagnostic.setqflist({
			namespace = namespace,
			open = false,
			title = "ESLint",
		})
	end)
end

local restart = function()
	System("eslint_d restart")
end

local on_save = function(buffer)
	buffer = if_nil(buffer, nvim_get_current_buf())

	autocmd("BufWritePost", {
		group = augroup,
		buffer = buffer,
		desc = "Runs eslint on save",
		callback = function(event)
			execute(event.buf)
		end,
	})

	autocmd("VimLeave", {
		group = augroup,
		desc = "Kills eslint_d when closing vim",
		callback = restart,
	})
end

local detect_changes = function()
	autocmd("BufWritePost", {
		group = augroup,
		pattern = file_patterns,
		desc = "Restarts eslint_d when its config file changes",
		callback = restart,
	})
end

local setup = function(buffer)
	buffer = if_nil(buffer, nvim_get_current_buf())

	command("ESLint", execute, { buffer = true })
	command("ESLintRestart", restart, { buffer = true })

	on_save(buffer)
	detect_changes()
end

return {
	augroup = augroup,
	execute = execute,
	restart = restart,
	format_on_save = on_save,
	detect_changes = detect_changes,
	setup = setup,
}
