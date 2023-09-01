local PLUGINS = {}

local add_local = function(path)
	local plugin = { remote = false }
	local parts = vim.split(path, "/")

	plugin.name = parts[#parts]
	PLUGINS[plugin.name] = plugin

	vim.opt.runtimepath:append(path)
end

local add_remote = function(plugin_name, plugin_opts)
	local plugin = { remote = true }

	plugin_opts = if_nil(plugin_opts, {})
	plugin.repo = vim.split(plugin_name, "/")
	plugin.name = plugin.repo[2]
	plugin.path = stdpath("data") .. "/site/pack/balls/start/" .. plugin.name

	if plugin_opts.on_sync and type(plugin_opts.on_sync) == "string" then
		if vim.startswith(plugin_opts.on_sync, ":") then
			plugin.on_sync = function()
				vim.cmd(plugin_opts.on_sync:sub(2))
				vim.info("Successfully executed `on_sync` for `%s`.", plugin_name)
			end
		else
			plugin.on_sync = function()
				System(plugin_opts.on_sync, function(result)
					if result.code ~= 0 then
						vim.error("Failed to execute sync routine for `%s`.", plugin_name)
					end

					vim.info("Successfully executed `on_sync` for `%s`.", plugin_name)
				end, {
					cmd = {
						cwd = plugin.path,
					},
				})
			end
		end
	else
		plugin.on_sync = plugin_opts.on_sync
	end

	PLUGINS[plugin.name] = plugin

	if not vim.uv.fs_stat(plugin.path) then
		local repo = table.concat(plugin.repo, "/")
		local command = { "git", "clone", "https://github.com/" .. repo .. ".git", plugin.path }

		System(command, function(result)
			if result.code ~= 0 then
				vim.error("Failed to clone plugin repository: %s", vim.inspect(result))
				return
			end

			vim.cmd("helptags ALL")

			if plugin.on_sync then
				pcall(plugin.on_sync)
			end

			vim.info("Successfully installed `%s`.", plugin.name)
		end)
	end
end

usercmd("SyncPlugins", function()
	local plugins = vim.tbl_keys(PLUGINS)

	for directory in vim.fs.dir(stdpath("data") .. "/site/pack/balls/start/") do
		if not vim.tbl_contains(plugins, directory) then
			System({ "rm", "-rf", stdpath("data") .. "/site/pack/balls/start/" .. directory })
			vim.info("Removed `%s`.", directory)
		end
	end

	for name, plugin in pairs(PLUGINS) do
		System({ "git", "pull" }, function(result)
			if result.code ~= 0 then
				vim.error("Failed to sync plugin repository: %s", vim.inspect(result))
				return
			end

			vim.cmd("helptags ALL")

			if plugin.on_sync then
				plugin.on_sync()
			end

			vim.info("Successfully synced `%s`.", name)
		end, {
			cmd = {
				cwd = plugin.path,
			},
		})
	end
end)

usercmd("ListPlugins", function()
	local text = {}

	for name, plugin in pairs(PLUGINS) do
		if not plugin.remote then
			table.insert(text, "• [local] " .. name)
		else
			table.insert(text, "• " .. name)
		end
	end

	table.sort(text)
	table.insert(text, "Total Plugins: " .. vim.tbl_count(text))

	SendToQf(table.concat(text, "\n"))
end)

return {
	add_local = add_local,
	add_remote = add_remote,
}
