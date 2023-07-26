usercmd("Git", function(cmd)
	Git(cmd.fargs)
end, {
	nargs = "+",
	desc = "Run any git command",
})
