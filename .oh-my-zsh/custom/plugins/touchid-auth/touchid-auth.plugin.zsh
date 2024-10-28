function () {
  # add line if not currently present in file
  grep -qx 'auth\s*sufficient\s*pam_tid\.so' /etc/pam.d/sudo || {
      tmp=$(mktemp)

      # Take the first line (the comment line) from the auth file
      head -1 /etc/pam.d/sudo >> $tmp

      # Insert our line as the first real line of the file - this ensures TouchID is tried _before_ password
      print 'auth       sufficient     pam_tid.so' >> $tmp

      # Copy the rest of the file
      tail -n +2 /etc/pam.d/sudo >> $tmp

      # Save to the auth file
      prompt='Trying to enable TouchID for `sudo` but command does not have `sudo` access - enter password to continue: '
      sudo -p "$prompt" cp /etc/pam.d/sudo /etc/pam.d/sudo.bak
      sudo -p "$prompt" mv $tmp /etc/pam.d/sudo

      print 'TouchID enabled for `sudo` - old `sudo` auth file backed up to /etc/pam.d/sudo.bak'

      # No need to remove the temp file because we moved it
  }
}
