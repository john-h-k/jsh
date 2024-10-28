_js_get_puzzle_name() {
	print $(ggrep -zoP '<div class="puzzle-header">\s*<div class="section-header-wrapper">\s*<h3>[^<]+</h3>' "$1" | ggrep -zoP '(?<=<h3>).+(?=</h3>)')
}

js_local_puzzle_name() {
	_js_get_puzzle_name ~/repos/jane_street_puzzles/current.html
}

js_current_puzzle_name() {
	curl https://www.janestreet.com/puzzles/current-puzzle/ -s -o ~/repos/jane_street_puzzles/newer.html
	_js_get_puzzle_name ~/repos/jane_street_puzzles/newer.html
	rm ~/repos/jane_street_puzzles/newer.html
}

js_update_puzzle() {
	if [[ $(js_local_puzzle_name) != $(js_current_puzzle_name) ]]; then
		print "New Jane Street puzzle!! '$(js_current_puzzle_name)'"
		curl https://www.janestreet.com/puzzles/current-puzzle/ -s -o ~/repos/jane_street_puzzles/current.html
		open https://www.janestreet.com/puzzles/current-puzzle/
	fi
}

#js_update_puzzle
