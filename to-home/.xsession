#!/bin/sh

# Default X wallpaper
~/.fehbg

# solft link to embeded data dir if any
if [ -d /run/archiso/bootmnt/data ] && [ -f ~/.firstboot ]; then
        ln -s /run/archiso/bootmnt/data "$(xdg-user-dir DESKTOP)"
        rm ~/.firstboot
fi

if [ -f ~/.firstboot ]; then
        rm ~/.firstboot
fi

export GTK_THEME=Adwaita:dark
export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
export QT_STYLE_OVERRIDE=Adwaita-Dark
