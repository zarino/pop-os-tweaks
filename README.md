# pop-os-tweaks

* Installs a xscreensaver, and all the gnome-shell extensions that I use.
* Sets xscreensaver to start on boot.
* Sets xscreensaver to be disabled whenever another app is a full screen (I primarily us this to prevent xscreensaver from kicking in while I’m using Steam in Big Picture Mode).
* Sets a bunch of OS settings that I prefer.
* *Doesn’t* set a desktop background image or lock screen image (see below).

## Requirements

* xscreensaver will look for images in `~/Pictures/Backgrounds/`.
* Only tested on [POP!_OS](https://system76.com/pop) 19.04.

## How to use

    cd
    git clone https://github.com/zarino/pop-os-tweaks.git
    cd pop-os-tweaks
    ./setup.sh

The script will ask for a root password so it can install packages.

It automatically reloads the gnome-shell, so you don’t need to do `Alt`-`F2` and `r`.

The files it copies into `~/.config/autostart` will take effect on the next login/restart.

## Desktop background and lock screen images

Desktop background and lock screen images can be set from the Settings app or via the command line. Eg:

    gsettings set org.gnome.desktop.background picture-uri 'file:///home/zarino/Pictures/Backgrounds/some-image-file.jpg'
    gsettings set org.gnome.desktop.screensaver picture-uri 'file:///home/zarino/Pictures/Backgrounds/some-image-file.jpg'
