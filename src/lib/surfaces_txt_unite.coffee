surfaces_txt_unite = {}

surfaces_txt_unite.unite = (surfaces_txt) ->
	txt_lines = surfaces_txt.split /\r?\n/
	scope = null
	surface_lines = {}
	surface_lines_union = {}
	other_lines = []
	for line, index in txt_lines
		if line.match /^surface/
			scope = line.replace /{/, ''
			surface_lines[scope] = []
		else if scope? && line.match /^}/
			scope = null
		else if scope?
			if line.match /{/
				continue
			surface_lines[scope].push line
			unless surface_lines_union[line]?
				surface_lines_union[line] = []
			surface_lines_union[line].push scope
		else
			other_lines.push line
	surface_lines_in_scopes = {}
	for line, scopes of surface_lines_union
		if scopes.length > 1
			scope = scopes.sort().join(', ')
			unless surface_lines_in_scopes[scope]?
				surface_lines_in_scopes[scope] = []
			surface_lines_in_scopes[scope].push line
		else
			delete surface_lines_union[line]
	for scope, lines of surface_lines
		delete_index = []
		for line, index in lines
			if surface_lines_union[line]
				delete_index.push index
		delete_index.sort (a, b) -> b - a
		for index in delete_index
			lines.splice index, 1
	result_txt = ''
	for line in other_lines
		result_txt += line + '\r\n'
	for scope, lines of surface_lines
		result_txt += scope + '\r\n'
		result_txt += '{' + '\r\n'
		for line in lines
			result_txt += line + '\r\n'
		result_txt += '}' + '\r\n'
	for scope, lines of surface_lines_in_scopes
		result_txt += scope + '\r\n'
		result_txt += '{' + '\r\n'
		for line in lines
			result_txt += line + '\r\n'
		result_txt += '}' + '\r\n'
	result_txt

if exports?
	exports.unite = surfaces_txt_unite.unite
