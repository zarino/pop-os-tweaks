#!/bin/bash

DEBIAN_FRONTEND=noninteractive

# Get absolute path of current script's directory.
# https://stackoverflow.com/a/45392962
SCRIPT_PATH=${BASH_SOURCE[0]}
SCRIPT_DIR="$(cd "$(dirname "${SCRIPT_PATH:-$PWD}")" 2>/dev/null 1>&2 && pwd)"

# Get absolute path of current user's home directory.
HOME_DIR=$(cd; pwd)

# Install packages as sudo.
# Will prompt for password.
sudo su - <<EOF
apt-get -yqq update
apt-get -yqq remove gnome-screensaver
apt-get -yqq install xscreensaver xscreensaver-data-extra xscreensaver-gl-extra
EOF

# Symlink the gnome-shell extensions into place, and activate them.
mkdir -p "${HOME_DIR}/.local/share/gnome-shell/extensions"
EXTENSIONS=$(ls ${SCRIPT_DIR}/gnome-shell-extensions/)
for extension in $EXTENSIONS
do
    rm -rf "${HOME_DIR}/.local/share/gnome-shell/extensions/${extension}"
    ln -s "${SCRIPT_DIR}/gnome-shell-extensions/${extension}" "${HOME_DIR}/.local/share/gnome-shell/extensions/${extension}"
    gnome-shell-extension-tool -e "${extension}"
done

# Create a .desktop file to load xscreensaver in the background on startup.
mkdir -p "${HOME_DIR}/.config/autostart"
rm -rf "${HOME_DIR}/.config/autostart/xscreensaver.desktop"
ln -s "${SCRIPT_DIR}/xscreensaver.desktop" "${HOME_DIR}/.config/autostart/xscreensaver.desktop"

# Create a .desktop file to run the fullscreen watcher in the background.
mkdir -p "${HOME_DIR}/.config/autostart"
rm -f "${HOME_DIR}/.config/autostart/xscreensaver-deactivate-on-fullscreen.desktop"
sed -e "s;%DIR%;$SCRIPT_DIR;g" "xscreensaver-deactivate-on-fullscreen.desktop.template" > "${HOME_DIR}/.config/autostart/xscreensaver-deactivate-on-fullscreen.desktop"

# Version-controlled xscreensaver config!
if [ -e "${HOME_DIR}/.xscreensaver" ]
    mv "${HOME_DIR}/.xscreensaver" "${HOME_DIR}/.xscreensaver.backup"
    echo "Existing ~/.xscreensaver config moved to ~/.xscreensaver.backup"
fi
cp "${SCRIPT_DIR}/xscreensaver-config" "${HOME_DIR}/.xscreensaver"

# Set "gnome tweaks"
cat "${SCRIPT_DIR}/gsettings.txt" | while read -r line
do
    gsettings set $line
done

sed -e "s;%HOME_DIR%;${HOME_DIR};g" "${SCRIPT_DIR}/gsettings-extensions.txt" | while read -r line
do
    gsettings $line
done

# Restart gnome-shell so that the new extensions are used.
# The command line equivalent of pressing `ALT`+`f2` and typing `r`.
killall -3 gnome-shell
