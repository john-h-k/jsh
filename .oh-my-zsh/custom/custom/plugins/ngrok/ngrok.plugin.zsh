find_ngrok_tunnel() {
	local res=$(curl -s "http://localhost:4040/api/tunnels")
	if [[ $res =~ '"public_url":"([^"]+)"' ]]; then
		print $match[1]
	fi
}
