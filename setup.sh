#!/bin/bash

DEBIAN_FRONTEND=noninteractive

# Get absolute path of current script's directory.
# https://stackoverflow.com/a/45392962
SCRIPT_PATH=${BASH_SOURCE[0]}
SCRIPT_DIR="$(cd "$(dirname "${SCRIPT_PATH:-$PWD}")" 2>/dev/null 1>&2 && pwd)"

# Get absolute path of current user's home directory.
HOME_DIR=$(cd; pwd)

echo '-- Installing packages (will require administrator permissions)'
# Install packages as sudo.
# Will prompt for password.
sudo su - <<EOF
apt-get -yqq update
apt-get -yqq install openssh-server
apt-get -yqq remove gnome-screensaver
apt-get -yqq install xscreensaver xscreensaver-data-extra xscreensaver-gl-extra
EOF

echo '-- Symlinking gnome-shell extensions'
# Symlink the gnome-shell extensions into place, and activate them.
mkdir -p "${HOME_DIR}/.local/share/gnome-shell/extensions"
EXTENSIONS=$(ls ${SCRIPT_DIR}/gnome-shell-extensions/)
for extension in $EXTENSIONS
do
    rm -rf "${HOME_DIR}/.local/share/gnome-shell/extensions/${extension}"
    ln -s "${SCRIPT_DIR}/gnome-shell-extensions/${extension}" "${HOME_DIR}/.local/share/gnome-shell/extensions/${extension}"
    gnome-shell-extension-tool -e "${extension}"
done

echo '-- Copying xscreensaver autostart files'
# Create a .desktop file to load xscreensaver in the background on startup.
mkdir -p "${HOME_DIR}/.config/autostart"
cp "${SCRIPT_DIR}/xscreensaver.desktop" "${HOME_DIR}/.config/autostart/xscreensaver.desktop"

# Create a .desktop file to run the fullscreen watcher in the background.
mkdir -p "${HOME_DIR}/.config/autostart"
sed -e "s;%DIR%;${SCRIPT_DIR};g" "xscreensaver-deactivate-on-fullscreen.desktop.template" > "${HOME_DIR}/.config/autostart/xscreensaver-deactivate-on-fullscreen.desktop"

echo '-- Writing xscreensaver config'
# Main xscreensaver config.
sed -e "s;%HOME_DIR%;${HOME_DIR};g" "xscreensaver-config.template" > "${HOME_DIR}/.xscreensaver"

# Create a directory for xscreensaver to find images in.
mkdir -p "${HOME_DIR}/Pictures/Backgrounds"

echo '-- Applying gnome settings'
# Set "gnome tweaks"
cat "${SCRIPT_DIR}/gsettings.txt" | while read -r line
do
    gsettings set $line
done

echo '-- Applying gnome extension settings'
sed -e "s;%HOME_DIR%;${HOME_DIR};g" "${SCRIPT_DIR}/gsettings-extensions.txt" | while read -r line
do
    gsettings $line
done

echo '-- Restarting gnome shell (will require administrator permissions)'
# Restart gnome-shell (equivalent of `ALT`+`f2` and `r`).
# Run as root to avoid "Operation not permitted" warning output.
# Will prompt for password.
sudo killall -3 gnome-shell

echo '-- Done!'
