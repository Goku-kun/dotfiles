#! /usr/bin/zsh

# Use this in the crontab setup (refresh the bg every 1 minute)
# */1  *  *  *  * gkun DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus /bin/zsh /home/gkun/init_scripts/updatedarkwall.sh >> /home/gkun/cron.log 2>&1

wallpaper=$(find ~gkun/Pictures/wallpapers -type f | shuf -n 1)
gsettings set org.gnome.desktop.background picture-uri-dark "file://$wallpaper"


