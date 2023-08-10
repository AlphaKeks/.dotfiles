local files = {
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

local function format_on_save()
	autocmd("BufWritePost", {
		desc = "Run prettier after saving",
		group = augroup("prettier-on-save"),
		buffer = bufnr(),
		callback = function()
			local command = { "prettier", "--write" }

			if not vim.fs.find(files, { upward = true })[1] then
				table.insert(command, "--config")
				table.insert(
					command,
					vim.env.HOME .. "/.dotfiles/configs/tools/prettier/prettier.config.js"
				)
			end

			table.insert(command, expand("%"))

			System(command, function()
				vim.cmd("e!")
			end)
		end,
	})
end

return { setup = format_on_save }
