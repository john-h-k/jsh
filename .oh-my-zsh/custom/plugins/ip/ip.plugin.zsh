ip() {
  local flag_help flag_local flag_public

  zparseopts -D -F - \
    {h,-help}=flag_help \
    {l,-local}=flag_local \
    {p,-public}=flag_public ||
    return 1

  if [[ $flag_local && $flag_public ]]; then
    print "Error: Cannot specify both --local and --public"
    return 1
  fi

  if [[ $flag_help ]]; then
    print "Usage: ip [-h|--help] [-l|--local] [-p|--public]"
    print "  -h, --help: Print this help message"
    print "  -l, --local: Print the local IP address"
    print "  -p, --public: Print the public IP address (default)"
    return 0
  fi

  [[ $flag_local ]] && { ipconfig getifaddr en0 } || { curl ipecho.net/plain; print }
}
