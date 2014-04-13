surfaces_txt_unite = {}

surfaces_txt_unite.unite = (surfaces_txt) ->
	txt_lines = surfaces_txt.split /\r?\n/
	scope = null
	surface_lines = {}
	surface_lines_union = {}
	surface_lines_animation = {}
	other_lines = []
	# read and store lines
	for line, index in txt_lines
		# begin surface scope
		if line.match /^surface/
			scope = line.replace(/\.append/, '').replace(/{/, '')
			unless surface_lines[scope]?
				surface_lines[scope] = []
		# end surface scope
		else if scope? && line.match /^}/
			scope = null
		# in surface scope
		else if scope?
			# bracket
			if line.match /{/
				continue
			# animation
			result = null
			if result = line.match /^\s*(?:animation)?(\d+)\.?(interval|pattern|option|collision)/
				animation_id = result[1]
				unless surface_lines_animation[scope]?
					surface_lines_animation[scope] = {}
				unless surface_lines_animation[scope][animation_id]?
					surface_lines_animation[scope][animation_id] = {lines: []}
				surface_lines_animation[scope][animation_id].lines.push line
			# not animation
			else
				surface_lines[scope].push line
				unless surface_lines_union[line]?
					surface_lines_union[line] = []
				surface_lines_union[line].push scope
		# out surface scope
		else
			other_lines.push line
	# select duplicated lines
	# construct to lines
	surface_lines_in_scopes = {}
	for line, scopes of surface_lines_union
		if line.length
			if scopes.length > 1
				scope = scopes.sort().join(',')
				unless surface_lines_in_scopes[scope]?
					surface_lines_in_scopes[scope] = []
				surface_lines_in_scopes[scope].push line
			else
				delete surface_lines_union[line]
	# delete duplicated lines
	for scope, lines of surface_lines
		delete_index = []
		for line, index in lines
			if surface_lines_union[line]
				delete_index.push index
		delete_index.sort (a, b) -> b - a
		for index in delete_index
			lines.splice index, 1
	# make animation union key
	surface_lines_union_animation = {}
	for scope, animations of surface_lines_animation
		for animation_id, contents of animations
			key = contents.lines.slice().sort().join('\r\n')
			contents.key = key
			unless surface_lines_union_animation[key]?
				surface_lines_union_animation[key] = {scopes: []}
			surface_lines_union_animation[key].lines = contents.lines
			surface_lines_union_animation[key].scopes.push scope
	# select duplicated animation lines
	# construct to lines
	surface_lines_animation_in_scopes = {}
	for key, contents of surface_lines_union_animation
		if contents.scopes.length > 1
			scope = contents.scopes.sort().join(',')
			unless surface_lines_animation_in_scopes[scope]?
				surface_lines_animation_in_scopes[scope] = []
			surface_lines_animation_in_scopes[scope] = surface_lines_animation_in_scopes[scope].concat contents.lines
		else
			delete surface_lines_union_animation[key]
	# delete duplicated animation lines
	for scope, animations of surface_lines_animation
		delete_index = []
		for animation_id, contents of animations
			if surface_lines_union_animation[contents.key]?
				delete animations[animation_id]
	# make text
	result_txt = ''
	continuous_empty_line_count = 0
	for line in other_lines
		if line.length
			continuous_empty_line_count = 0
			result_txt += line + '\r\n'
		else
			continuous_empty_line_count++
			if continuous_empty_line_count <= 5
				result_txt += line + '\r\n'
	single_scopes = {}
	for scope of surface_lines
		single_scopes[scope] = true
	for scope of surface_lines_animation
		single_scopes[scope] = true
	for scope of single_scopes
		scope_txt = ''
		if surface_lines[scope]?
			for line in surface_lines[scope]
				scope_txt += line + '\r\n'
		if surface_lines_animation[scope]?
			for animation_id, contents of surface_lines_animation[scope]
				for line in contents.lines
					scope_txt += line + '\r\n'
		if scope_txt.length
			result_txt += scope + '\r\n'
			result_txt += '{' + '\r\n'
			result_txt += scope_txt
			result_txt += '}' + '\r\n'
	multiple_scopes = {}
	for scope of surface_lines_in_scopes
		multiple_scopes[scope] = true
	for scope of surface_lines_animation_in_scopes
		multiple_scopes[scope] = true
	for scope of multiple_scopes
		scope_txt = ''
		if surface_lines_in_scopes[scope]?
			for line in surface_lines_in_scopes[scope]
				scope_txt += line + '\r\n'
		if surface_lines_animation_in_scopes[scope]?
			for line in surface_lines_animation_in_scopes[scope]
				scope_txt += line + '\r\n'
		if scope_txt.length
			result_txt += scope + '\r\n'
			result_txt += '{' + '\r\n'
			result_txt += scope_txt
			result_txt += '}' + '\r\n'
	result_txt

if exports?
	exports.unite = surfaces_txt_unite.unite
