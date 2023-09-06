local file_patterns = {
	".prettierrc",
	".prettierrc.json",
	".prettierrc.yml",
	".prettierrc.yaml",
	".prettierrc.json5",
	".prettierrc.js",
	".prettierrc.cjs",
	".prettierrc.toml",
	"prettier.config.js",
	"prettier.config.cjs",
}

local augroup = augroup("alphakeks-prettier")

local execute = function(buffer)
	buffer = if_nil(buffer, nvim_get_current_buf())

	System("prettierd " .. expand("%"), function(result)
		if result.code ~= 0 then
			return vim.warn("Failed to execute prettier")
		end

		nvim_buf_set_lines(buffer, 0, -1, false, vim.split(result.stdout, "\n", { trimempty = true }))
	end, {
		stdin = nvim_buf_get_lines(buffer, 0, -1, false),
		env = {
			PRETTIERD_DEFAULT_CONFIG = vim.env.HOME
					.. "/.dotfiles/configs/tools/prettier/prettier.config.js",
		},
	})
end

local restart = function()
	System("prettierd restart")
end

local on_save = function(buffer)
	buffer = if_nil(buffer, nvim_get_current_buf())

	autocmd("BufWritePre", {
		group = augroup,
		buffer = buffer,
		desc = "Runs prettier on save",
		callback = function(event)
			execute(event.buf)
		end,
	})

	autocmd("VimLeave", {
		group = augroup,
		desc = "Kills prettierd when closing vim",
		callback = restart,
	})
end

local detect_changes = function()
	autocmd("BufWritePost", {
		group = augroup,
		pattern = file_patterns,
		desc = "Restarts prettier when its config file changes",
		callback = restart,
	})
end

local setup = function(buffer)
	buffer = if_nil(buffer, nvim_get_current_buf())

	command("Prettier", execute, { buffer = true })
	command("PrettierRestart", restart, { buffer = true })

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
