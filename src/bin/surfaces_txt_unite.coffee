surfaces_txt_unite = require 'surfaces_txt_unite'

txt = ''

process.stdin.on 'data', (chunk) ->
	txt += chunk

process.stdin.on 'end', ->
	console.log surfaces_txt_unite.unite txt

