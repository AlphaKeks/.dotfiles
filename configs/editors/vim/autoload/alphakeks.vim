function alphakeks#tabline()
	let string = "  "

	for tab_idx in range(tabpagenr("$"))
		if tab_idx + 1 == tabpagenr()
			let string ..= "%#TabLineSel#"
		else
			let string ..= "%#TabLine#"
		endif

		let string ..= "%" .. (tab_idx + 1)
		let string ..= " %{alphakeks#tablabel(" .. (tab_idx + 1) .. ")} "
	endfor

	let string ..= "%#TabLineFill#%T"

	return string
endfunction

function alphakeks#tablabel(n)
	let buflist = tabpagebuflist(a:n)
	let win = tabpagewinnr(a:n)
	return bufname(buflist[win - 1])
endfunction
