#!/usr/bin/env bash
# https://privacy.sexy — v0.13.8 — Fri, 27 Mar 2026 13:39:19 GMT
if [ "$EUID" -ne 0 ]; then
  script_path=$([[ "$0" = /* ]] && echo "$0" || echo "$PWD/${0#./}")
  sudo "$script_path" || (
    echo 'Administrator privileges are required.'
    exit 1
  )
  exit 0
fi

# ----------------------------------------------------------
# ---------------------Clear DNS cache----------------------
# ----------------------------------------------------------
echo '--- Clear DNS cache'
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
# ----------------------------------------------------------

# ----------------------------------------------------------
# ------------------Clear inactive memory-------------------
# ----------------------------------------------------------
echo '--- Clear inactive memory'
sudo purge
# ----------------------------------------------------------

# ----------------------------------------------------------
# ----------------Disable Firefox telemetry-----------------
# ----------------------------------------------------------
echo '--- Disable Firefox telemetry'
# Enable Firefox policies so the telemetry can be configured.
sudo defaults write /Library/Preferences/org.mozilla.firefox EnterprisePoliciesEnabled -bool TRUE
# Disable sending usage data
sudo defaults write /Library/Preferences/org.mozilla.firefox DisableTelemetry -bool TRUE
# ----------------------------------------------------------

# ----------------------------------------------------------
# ------------Disable Microsoft Office telemetry------------
# ----------------------------------------------------------
echo '--- Disable Microsoft Office telemetry'
defaults write com.microsoft.office DiagnosticDataTypePreference -string ZeroDiagnosticData
# ----------------------------------------------------------

# ----------------------------------------------------------
# ---------Disable Homebrew user behavior analytics---------
# ----------------------------------------------------------
echo '--- Disable Homebrew user behavior analytics'
command='export HOMEBREW_NO_ANALYTICS=1'
declare -a profile_files=("$HOME/.bash_profile" "$HOME/.zprofile")
for profile_file in "${profile_files[@]}"; do
  touch "$profile_file"
  if ! grep -q "$command" "${profile_file}"; then
    echo "$command" >>"$profile_file"
    echo "[$profile_file] Configured"
  else
    echo "[$profile_file] No need for any action, already configured"
  fi
done
# ----------------------------------------------------------

# ----------------------------------------------------------
# --------------Disable NET Core CLI telemetry--------------
# ----------------------------------------------------------
echo '--- Disable NET Core CLI telemetry'
command='export DOTNET_CLI_TELEMETRY_OPTOUT=1'
declare -a profile_files=("$HOME/.bash_profile" "$HOME/.zprofile")
for profile_file in "${profile_files[@]}"; do
  touch "$profile_file"
  if ! grep -q "$command" "${profile_file}"; then
    echo "$command" >>"$profile_file"
    echo "[$profile_file] Configured"
  else
    echo "[$profile_file] No need for any action, already configured"
  fi
done
# ----------------------------------------------------------

# ----------------------------------------------------------
# ------------Disable PowerShell Core telemetry-------------
# ----------------------------------------------------------
echo '--- Disable PowerShell Core telemetry'
command='export POWERSHELL_TELEMETRY_OPTOUT=1'
declare -a profile_files=("$HOME/.bash_profile" "$HOME/.zprofile")
for profile_file in "${profile_files[@]}"; do
  touch "$profile_file"
  if ! grep -q "$command" "${profile_file}"; then
    echo "$command" >>"$profile_file"
    echo "[$profile_file] Configured"
  else
    echo "[$profile_file] No need for any action, already configured"
  fi
done
# ----------------------------------------------------------

# ----------------------------------------------------------
# --Disable automatic storage of documents in iCloud Drive--
# ----------------------------------------------------------
echo '--- Disable automatic storage of documents in iCloud Drive'
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# ----------------------------------------------------------

# Disable personalized advertisements and identifier tracking
echo '--- Disable personalized advertisements and identifier tracking'
defaults write com.apple.AdLib allowIdentifierForAdvertising -bool false
defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false
defaults write com.apple.AdLib forceLimitAdTracking -bool true
# ----------------------------------------------------------

# ----------------------------------------------------------
# --------------------Clear bash history--------------------
# ----------------------------------------------------------
echo '--- Clear bash history'
rm -f ~/.bash_history
# ----------------------------------------------------------

# ----------------------------------------------------------
# --------------------Clear zsh history---------------------
# ----------------------------------------------------------
echo '--- Clear zsh history'
rm -f ~/.zsh_history
# ----------------------------------------------------------

# ----------------------------------------------------------
# -------------------Clear Mail app logs--------------------
# ----------------------------------------------------------
echo '--- Clear Mail app logs'
# Clear directory contents: "$HOME/Library/Containers/com.apple.mail/Data/Library/Logs/Mail"
glob_pattern="$HOME/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/*"
rm -rfv $glob_pattern
# ----------------------------------------------------------

# ----------------------------------------------------------
# --------------Clear system maintenance logs---------------
# ----------------------------------------------------------
echo '--- Clear system maintenance logs'
# Delete files matching pattern: "/private/var/log/daily.out"
glob_pattern="/private/var/log/daily.out"
sudo rm -fv $glob_pattern
# Delete files matching pattern: "/private/var/log/weekly.out"
glob_pattern="/private/var/log/weekly.out"
sudo rm -fv $glob_pattern
# Delete files matching pattern: "/private/var/log/monthly.out"
glob_pattern="/private/var/log/monthly.out"
sudo rm -fv $glob_pattern
# ----------------------------------------------------------

# ----------------------------------------------------------
# --------------------Clear Adobe cache---------------------
# ----------------------------------------------------------
echo '--- Clear Adobe cache'
sudo rm -rfv ~/Library/Application\ Support/Adobe/Common/Media\ Cache\ Files/* &>/dev/null
# ----------------------------------------------------------

# ----------------------------------------------------------
# -------------------Clear Dropbox cache--------------------
# ----------------------------------------------------------
echo '--- Clear Dropbox cache'
if [ -d "~/Dropbox/.dropbox.cache" ]; then
  sudo rm -rfv ~/Dropbox/.dropbox.cache/* &>/dev/null
fi
# ----------------------------------------------------------

# ----------------------------------------------------------
# -----------Clear Google Drive File Stream cache-----------
# ----------------------------------------------------------
echo '--- Clear Google Drive File Stream cache'
killall "Google Drive File Stream"
rm -rfv ~/Library/Application\ Support/Google/DriveFS/[0-9a-zA-Z]*/content_cache &>/dev/null
# ----------------------------------------------------------

# ----------------------------------------------------------
# ------------------Clear iOS photo cache-------------------
# ----------------------------------------------------------
echo '--- Clear iOS photo cache'
rm -rf ~/Pictures/iPhoto\ Library/iPod\ Photo\ Cache/*
# ----------------------------------------------------------

# ----------------------------------------------------------
# ---------Disable Parallels Desktop advertisements---------
# ----------------------------------------------------------
echo '--- Disable Parallels Desktop advertisements'
defaults write 'com.parallels.Parallels Desktop' 'ProductPromo.ForcePromoOff' -bool yes
defaults write 'com.parallels.Parallels Desktop' 'WelcomeScreenPromo.PromoOff' -bool yes
# ----------------------------------------------------------

# ----------------------------------------------------------
# ------Disable participation in Siri data collection-------
# ----------------------------------------------------------
echo '--- Disable participation in Siri data collection'
defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2
# ----------------------------------------------------------

# ----------------------------------------------------------
# ---------------Enable application firewall----------------
# ----------------------------------------------------------
echo '--- Enable application firewall'
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo defaults write /Library/Preferences/com.apple.alf globalstate -bool true
defaults write com.apple.security.firewall EnableFirewall -bool true
# ----------------------------------------------------------

# ----------------------------------------------------------
# -----------------Enable firewall logging------------------
# ----------------------------------------------------------
echo '--- Enable firewall logging'
/usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true
# ----------------------------------------------------------

# ----------------------------------------------------------
# -------------------Enable stealth mode--------------------
# ----------------------------------------------------------
echo '--- Enable stealth mode'
/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true
defaults write com.apple.security.firewall EnableStealthMode -bool true
# ----------------------------------------------------------

# ----------------------------------------------------------
# -------Disable incoming SSH and SFTP remote logins--------
# ----------------------------------------------------------
echo '--- Disable incoming SSH and SFTP remote logins'
echo 'yes' | sudo systemsetup -setremotelogin off
# ----------------------------------------------------------

# ----------------------------------------------------------
# ------------Disable the insecure TFTP service-------------
# ----------------------------------------------------------
echo '--- Disable the insecure TFTP service'
sudo launchctl disable 'system/com.apple.tftpd'
# ----------------------------------------------------------

# ----------------------------------------------------------
# ----------Disable Bonjour multicast advertising-----------
# ----------------------------------------------------------
echo '--- Disable Bonjour multicast advertising'
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true
# ----------------------------------------------------------

# ----------------------------------------------------------
# -------------Disable insecure telnet protocol-------------
# ----------------------------------------------------------
echo '--- Disable insecure telnet protocol'
sudo launchctl disable system/com.apple.telnetd
# ----------------------------------------------------------

# ----------------------------------------------------------
# ----Disable local printer sharing with other computers----
# ----------------------------------------------------------
echo '--- Disable local printer sharing with other computers'
cupsctl --no-share-printers
# ----------------------------------------------------------

# Disable printing from external addresses, including the internet
echo '--- Disable printing from external addresses, including the internet'
cupsctl --no-remote-any
# ----------------------------------------------------------

# ----------------------------------------------------------
# ----------Disable remote printer administration-----------
# ----------------------------------------------------------
echo '--- Disable remote printer administration'
cupsctl --no-remote-admin
# ----------------------------------------------------------

# ----------------------------------------------------------
# ------Clear Safari cached blobs, URLs and timestamps------
# ----------------------------------------------------------
echo '--- Clear Safari cached blobs, URLs and timestamps'
rm -f ~/Library/Caches/com.apple.Safari/Cache.db
# ----------------------------------------------------------

# ----------------------------------------------------------
# -----------Clear Safari URL bar web page icons------------
# ----------------------------------------------------------
echo '--- Clear Safari URL bar web page icons'
rm -f ~/Library/Safari/WebpageIcons.db
# ----------------------------------------------------------

# ----------------------------------------------------------
# --------Clear Safari webpage previews (thumbnails)--------
# ----------------------------------------------------------
echo '--- Clear Safari webpage previews (thumbnails)'
rm -rfv ~/Library/Caches/com.apple.Safari/Webpage\ Previews
# ----------------------------------------------------------

# ----------------------------------------------------------
# --------------Clear Safari browsing history---------------
# ----------------------------------------------------------
echo '--- Clear Safari browsing history'
rm -f ~/Library/Safari/History.db
rm -f ~/Library/Safari/History.db-lock
rm -f ~/Library/Safari/History.db-shm
rm -f ~/Library/Safari/History.db-wal
# For older versions of Safari
rm -f ~/Library/Safari/History.plist   # URL, visit count, webpage title, last visited timestamp, redirected URL, autocomplete
rm -f ~/Library/Safari/HistoryIndex.sk # History index
# ----------------------------------------------------------

# ----------------------------------------------------------
# --------------Clear Safari downloads history--------------
# ----------------------------------------------------------
echo '--- Clear Safari downloads history'
rm -f ~/Library/Safari/Downloads.plist
# ----------------------------------------------------------

# ----------------------------------------------------------
# ----------Clear Safari frequently visited sites-----------
# ----------------------------------------------------------
echo '--- Clear Safari frequently visited sites'
rm -f ~/Library/Safari/TopSites.plist
# ----------------------------------------------------------

# ----------------------------------------------------------
# ------Clear Safari last session (open tabs) history-------
# ----------------------------------------------------------
echo '--- Clear Safari last session (open tabs) history'
rm -f ~/Library/Safari/LastSession.plist
# ----------------------------------------------------------

# ----------------------------------------------------------
# ----------------Clear Safari history copy-----------------
# ----------------------------------------------------------
echo '--- Clear Safari history copy'
rm -rfv ~/Library/Caches/Metadata/Safari/History
# ----------------------------------------------------------

# ----------------------------------------------------------
# -Clear search term history embedded in Safari preferences-
# ----------------------------------------------------------
echo '--- Clear search term history embedded in Safari preferences'
defaults write ~/Library/Preferences/com.apple.Safari RecentSearchStrings '( )'
# ----------------------------------------------------------

# ----------------------------------------------------------
# -------------------Clear Safari cookies-------------------
# ----------------------------------------------------------
echo '--- Clear Safari cookies'
rm -f ~/Library/Cookies/Cookies.binarycookies
# Used before Safari 5.1
rm -f ~/Library/Cookies/Cookies.plist
# ----------------------------------------------------------

# ----------------------------------------------------------
# -------Clear Safari zoom level preferences per site-------
# ----------------------------------------------------------
echo '--- Clear Safari zoom level preferences per site'
rm -f ~/Library/Safari/PerSiteZoomPreferences.plist
# ----------------------------------------------------------

# ----------------------------------------------------------
# -------Clear allowed URLs for Safari notifications--------
# ----------------------------------------------------------
echo '--- Clear allowed URLs for Safari notifications'
rm -f ~/Library/Safari/UserNotificationPreferences.plist
# ----------------------------------------------------------

# Clear Safari preferences for downloads, geolocation, pop-ups, and autoplay per site
echo '--- Clear Safari preferences for downloads, geolocation, pop-ups, and autoplay per site'
rm -f ~/Library/Safari/PerSitePreferences.db
# ----------------------------------------------------------

# ----------------------------------------------------------
# -------------------Clear Firefox cache--------------------
# ----------------------------------------------------------
echo '--- Clear Firefox cache'
sudo rm -rf ~/Library/Caches/Mozilla/
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/netpredictions.sqlite
# ----------------------------------------------------------

# ----------------------------------------------------------
# ----------------Clear Firefox form history----------------
# ----------------------------------------------------------
echo '--- Clear Firefox form history'
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/formhistory.sqlite
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/formhistory.dat
# ----------------------------------------------------------

# ----------------------------------------------------------
# --------------Clear Firefox site preferences--------------
# ----------------------------------------------------------
echo '--- Clear Firefox site preferences'
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/content-prefs.sqlite
# ----------------------------------------------------------

# Clear Firefox session restore data (loads after the browser closes or crashes)
echo '--- Clear Firefox session restore data (loads after the browser closes or crashes)'
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionCheckpoints.json
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionstore*.js*
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionstore.bak*
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionstore-backups/previous.js*
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionstore-backups/recovery.js*
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionstore-backups/recovery.bak*
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionstore-backups/previous.bak*
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/sessionstore-backups/upgrade.js*-20*
# ----------------------------------------------------------

# ----------------------------------------------------------
# -----------------Clear Firefox passwords------------------
# ----------------------------------------------------------
echo '--- Clear Firefox passwords'
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/signons.txt
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/signons2.txt
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/signons3.txt
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/signons.sqlite
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/logins.json
# ----------------------------------------------------------

# ----------------------------------------------------------
# ---------------Clear Firefox HTML5 cookies----------------
# ----------------------------------------------------------
echo '--- Clear Firefox HTML5 cookies'
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/webappsstore.sqlite
# ----------------------------------------------------------

# ----------------------------------------------------------
# ---------------Clear Firefox crash reports----------------
# ----------------------------------------------------------
echo '--- Clear Firefox crash reports'
rm -rfv ~/Library/Application\ Support/Firefox/Crash\ Reports/
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/minidumps/*.dmp
# ----------------------------------------------------------

# ----------------------------------------------------------
# ----------------Clear Firefox backup files----------------
# ----------------------------------------------------------
echo '--- Clear Firefox backup files'
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/bookmarkbackups/*.json
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/bookmarkbackups/*.jsonlz4
# ----------------------------------------------------------

# ----------------------------------------------------------
# ------------------Clear Firefox cookies-------------------
# ----------------------------------------------------------
echo '--- Clear Firefox cookies'
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/cookies.txt
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/cookies.sqlite
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/cookies.sqlite-shm
rm -fv ~/Library/Application\ Support/Firefox/Profiles/*/cookies.sqlite-wal
rm -rfv ~/Library/Application\ Support/Firefox/Profiles/*/storage/default/http*
# ----------------------------------------------------------

# ----------------------------------------------------------
# --------------Clear Chrome browsing history---------------
# ----------------------------------------------------------
echo '--- Clear Chrome browsing history'
rm -rfv ~/Library/Application\ Support/Google/Chrome/Default/History &>/dev/null
rm -rfv ~/Library/Application\ Support/Google/Chrome/Default/History-journal &>/dev/null
# ----------------------------------------------------------

# ----------------------------------------------------------
# --------------------Clear Chrome cache--------------------
# ----------------------------------------------------------
echo '--- Clear Chrome cache'
sudo rm -rfv ~/Library/Application\ Support/Google/Chrome/Default/Application\ Cache/* &>/dev/null
# ----------------------------------------------------------

# ----------------------------------------------------------
# ---------------Disable guest account login----------------
# ----------------------------------------------------------
echo '--- Disable guest account login'
sudo defaults write '/Library/Preferences/com.apple.loginwindow' 'GuestEnabled' -bool NO
if ! command -v 'sysadminctl' &>/dev/null; then
  echo 'Skipping because "sysadminctl" is not found.'
else
  sudo sysadminctl -guestAccount off
fi
# ----------------------------------------------------------

# ----------------------------------------------------------
# -----------Disable guest file sharing over SMB------------
# ----------------------------------------------------------
echo '--- Disable guest file sharing over SMB'
sudo defaults write '/Library/Preferences/SystemConfiguration/com.apple.smb.server' 'AllowGuestAccess' -bool NO
if ! command -v 'sysadminctl' &>/dev/null; then
  echo 'Skipping because "sysadminctl" is not found.'
else
  sudo sysadminctl -smbGuestAccess off
fi
# ----------------------------------------------------------

# ----------------------------------------------------------
# -----------Disable guest file sharing over AFP------------
# ----------------------------------------------------------
echo '--- Disable guest file sharing over AFP'
sudo defaults write '/Library/Preferences/com.apple.AppleFileServer' 'guestAccess' -bool NO
if ! command -v 'sysadminctl' &>/dev/null; then
  echo 'Skipping because "sysadminctl" is not found.'
else
  sudo sysadminctl -afpGuestAccess off
fi
sudo killall -HUP AppleFileServer
# ----------------------------------------------------------

# ----------------------------------------------------------
# --------------------Disable "Ask Siri"--------------------
# ----------------------------------------------------------
echo '--- Disable "Ask Siri"'
defaults write com.apple.assistant.support 'Assistant Enabled' -bool false
# ----------------------------------------------------------

# ----------------------------------------------------------
# ---------------Disable Siri voice feedback----------------
# ----------------------------------------------------------
echo '--- Disable Siri voice feedback'
defaults write com.apple.assistant.backedup 'Use device speaker for TTS' -int 3
# ----------------------------------------------------------

# ----------------------------------------------------------
# -------Disable Siri services (Siri and assistantd)--------
# ----------------------------------------------------------
echo '--- Disable Siri services (Siri and assistantd)'
launchctl disable "user/$UID/com.apple.assistantd"
launchctl disable "gui/$UID/com.apple.assistantd"
sudo launchctl disable 'system/com.apple.assistantd'
launchctl disable "user/$UID/com.apple.Siri.agent"
launchctl disable "gui/$UID/com.apple.Siri.agent"
sudo launchctl disable 'system/com.apple.Siri.agent'
if [ $(/usr/bin/csrutil status | awk '/status/ {print $5}' | sed 's/\.$//') = "enabled" ]; then
  >&2 echo 'This script requires SIP to be disabled. Read more: https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection'
fi
# ----------------------------------------------------------

# ----------------------------------------------------------
# -------Disable "Do you want to enable Siri?" pop-up-------
# ----------------------------------------------------------
echo '--- Disable "Do you want to enable Siri?" pop-up'
defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool True
# ----------------------------------------------------------

# ----------------------------------------------------------
# ----------------Remove Siri from menu bar-----------------
# ----------------------------------------------------------
echo '--- Remove Siri from menu bar'
defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0
# ----------------------------------------------------------

# ----------------------------------------------------------
# ---------------Remove Siri from status menu---------------
# ----------------------------------------------------------
echo '--- Remove Siri from status menu'
defaults write com.apple.Siri 'StatusMenuVisible' -bool false
defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true
# ----------------------------------------------------------

# ----------------------------------------------------------
# ----------------Empty trash on all volumes----------------
# ----------------------------------------------------------
echo '--- Empty trash on all volumes'
# on all mounted volumes
sudo rm -rfv /Volumes/*/.Trashes/* &>/dev/null
# on main HDD
sudo rm -rfv ~/.Trash/* &>/dev/null
# ----------------------------------------------------------

# ----------------------------------------------------------
# --------------------Remove Guest User---------------------
# ----------------------------------------------------------
echo '--- Remove Guest User'
if ! command -v 'sysadminctl' &>/dev/null; then
  echo 'Skipping because "sysadminctl" is not found.'
else
  sudo sysadminctl -deleteUser Guest
fi
if ! command -v 'fdesetup' &>/dev/null; then
  echo 'Skipping because "fdesetup" is not found.'
else
  sudo fdesetup remove -user Guest
fi
if ! command -v 'dscl' &>/dev/null; then
  echo 'Skipping because "dscl" is not found.'
else
  sudo dscl . delete /Users/Guest
fi
# ----------------------------------------------------------

echo 'Your privacy and security is now hardened 🎉💪'
echo 'Press any key to exit.'
read -n 1 -s
