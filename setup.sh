#!/bin/bash

# Get absolute path of current script's directory.
# https://stackoverflow.com/a/45392962
SCRIPT_PATH=${BASH_SOURCE[0]}
SCRIPT_DIR="$(cd "$(dirname "${SCRIPT_PATH:-$PWD}")" 2>/dev/null 1>&2 && pwd)"

# Get absolute path of current user's home directory.
HOME_DIR="$(cd; pwd)"

# Symlink the gnome-shell extensions into place.
mkdir -p "${HOME_DIR}/.local/share/gnome-shell/extensions"
EXTENSIONS=$(ls ${SCRIPT_DIR}/gnome-shell-extensions/)
for extension in $EXTENSIONS
do
    rm -rf "${HOME_DIR}/.local/share/gnome-shell/extensions/${extension}"
    ln -s "${SCRIPT_DIR}/gnome-shell-extensions/${extension}" "${HOME_DIR}/.local/share/gnome-shell/extensions/${extension}"
done

# Create a .desktop file to load xscreensaver in the background on startup.
mkdir -p "${HOME_DIR}/.config/autostart"
rm -rf "${HOME_DIR}/.config/autostart/xscreensaver.desktop"
ln -s "${SCRIPT_DIR}/xscreensaver.desktop" "${HOME_DIR}/.config/autostart/xscreensaver.desktop"

# Create a .desktop file to run the fullscreen watcher in the background.
mkdir -p "${HOME_DIR}/.config/autostart"
rm -f "${HOME_DIR}/.config/autostart/xscreensaver-deactivate-on-fullscreen.desktop"
sed -e "s;%DIR%;$SCRIPT_DIR;g" "xscreensaver-deactivate-on-fullscreen.desktop.template" > "${HOME_DIR}/.config/autostart/xscreensaver-deactivate-on-fullscreen.desktop"

# Restart gnome-shell so that the new extensions are used.
# The command line equivalent of pressing `ALT`+`f2` and typing `r`.
killall -3 gnome-shell
