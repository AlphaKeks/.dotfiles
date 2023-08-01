usercmd("RunOnSave", function(cmd)
	RunOnSave(cmd.args)
end, {
	desc = "Runs the given code when the current buffer is saved",
	nargs = 1,
})

usercmd("ClearRunOnSave", function(cmd)
	local opts = { group = "run-on-save" }

	if #cmd.args > 0 then
		if cmd.args == "current" then
			opts.buffer = bufnr()
		else
			opts.buffer = tonumber(cmd.args)
		end
	end

	clear_autocmds(opts)
end, {
	desc = "Clears run-on-save autocmds",
	nargs = "?",
	complete = function()
		return { "current" }
	end,
})
