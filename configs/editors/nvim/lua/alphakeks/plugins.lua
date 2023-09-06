local PLUGINS = {}

local add_local = function(path, options)
	options = if_nil(options, {})

	local path_segments = vim.split(path, "/")
	local plugin_name = path_segments[#path_segments]

	options.name = plugin_name
	options.path = path
	options.is_local = true
	PLUGINS[plugin_name] = options

	vim.opt.runtimepath:append(path)
	return options
end

local add_remote = function(uri, options)
	options = if_nil(options, {})

	local plugin = {
		is_local = false,
		uri = vim.split(uri, "/"),
	}

	plugin.name = plugin.uri[2]
	plugin.path = stdpath("data") .. "/site/pack/balls/start/" .. plugin.name

	if options.on_sync then
		if type(options.on_sync) == "string" then
			if vim.startswith(options.on_sync, ":") then
				plugin.on_sync = function(self)
					vim.cmd(options.on_sync:sub(2))
					vim.info("Executed on_sync routine for %s.", plugin.name)
				end
			else
				plugin.on_sync = function(self)
					System(options.on_sync, function(result)
						if result.code ~= 0 then
							return vim.error(
								"Error executing on_sync routine for %s: %s",
								plugin.name,
								vim.inspect(result)
							)
						end

						vim.info("Executed on_sync routine for %s.", plugin.name)
					end, { cwd = plugin.path })
				end
			end
		elseif type(options.on_sync) == "function" then
			plugin.on_sync = options.on_sync
		end
	end

	PLUGINS[plugin.name] = plugin

	if vim.uv.fs_stat(plugin.path) then
		return plugin
	end

	local command = string.format(
		"git clone https://github.com/%s.git %s",
		table.concat(plugin.uri, "/"),
		plugin.path
	)

	System(command, function(result)
		if result.code ~= 0 then
			return vim.error("Failed to clone plugin repository: %s", vim.inspect(result))
		end

		vim.cmd("helptags ALL")
		vim.info("Generated helptags for %s", plugin.name)

		if plugin.on_sync then
			plugin:on_sync()
		end

		vim.info("Installed %s.", plugin.name)
	end)

	return plugin
end

command("SyncPlugins", function()
	local plugins = vim.tbl_keys(PLUGINS)
	local plugin_path = stdpath("data") .. "/site/pack/balls/start/"

	for directory in vim.fs.dir(plugin_path) do
		if not vim.tbl_contains(plugins, directory) then
			System({ "rm", "-rf", plugin_path .. directory }, function()
				vim.info("Removed %s.", directory)
			end)
		end
	end

	for _, plugin in pairs(PLUGINS) do
		System("git pull", function(result)
			if result.code ~= 0 then
				return vim.error("Failed to sync plugin repository: %s", vim.inspect(result))
			end

			vim.cmd("helptags ALL")
			vim.info("Generated helptags for %s", plugin.name)

			if plugin.on_sync then
				plugin:on_sync()
			end

			vim.info("Synced %s.", plugin.name)
		end, { cwd = plugin.path })
	end
end)

command("ListPlugins", function()
	local list = {}

	for _, plugin in pairs(PLUGINS) do
		local text = "• " .. plugin.name

		if plugin.is_local then
			text = text .. " [local]"
		end

		table.insert(list, text)
	end

	table.sort(list)
	table.insert(list, 1, "Total Plugins: " .. vim.tbl_count(list))

	SendToQf(list)
end)

return {
	plugins = PLUGINS,
	add_local = add_local,
	add_remote = add_remote,
}
