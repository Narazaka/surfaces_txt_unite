all:
	coffee -o ../bin -c bin/surfaces_txt_unite.coffee
	coffee -o ../lib -cb lib/surfaces_txt_unite.coffee
	perl -i".old" -pe "$$.==1&&s@^@#!/usr/bin/env node\n@" ../bin/surfaces_txt_unite.js
	perl -e "unlink '../bin/surfaces_txt_unite.js.old'"
