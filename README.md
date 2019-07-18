# pop-os-tweaks

* Installs a few gnome-shell extensions that I use.
* Sets xscreensaver to start on boot.
* Sets xscreensaver to be disabled whenever another app is a full screen (I primarily us this to prevent xscreensaver from kicking in while I’m using Steam in Big Picture Mode).

## Requirements

* Assumes `xscreensaver` is installed.
* Only tested on [POP!_OS](https://system76.com/pop) 19.04.

## How to use

    cd
    git clone https://github.com/zarino/pop-os-tweaks.git
    cd pop-os-tweaks
    ./setup.sh

The script will ask for a root password so it can install packages.

It automatically reloads the gnome-shell, so you don’t need to do `Alt`-`F2` and `r`.

The files it copies into `~/.config/autostart` will take effect on the next login/restart.
