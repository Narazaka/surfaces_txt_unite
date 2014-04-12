window.onload = ->
	document.getElementById('to').onclick = ->
		txt_str = document.getElementById('txt').value
		try
			united_txt = surfaces_txt_unite.unite txt_str
		catch e
			alert e
		document.getElementById('united').value = united_txt
	document.getElementById('set_example').onclick = ->
		txt_str = ajax.gets('examples/surfaces.txt')
		document.getElementById('txt').value = txt_str
