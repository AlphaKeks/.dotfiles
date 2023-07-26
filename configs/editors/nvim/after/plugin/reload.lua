usercmd("ReloadPlugin", function(cmd)
	ReloadPlugin(cmd.args)
end, {
	nargs = 1,
	desc = "Reloads the configuration for the given plugin",
	complete = function()
		return vim.tbl_map(function(file)
			return file:match("(.-).lua")
		end, readdir(stdpath("config") .. "/lua/plugins"))
	end,
})
