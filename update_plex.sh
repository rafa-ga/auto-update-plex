#!/bin/bash

redirect_url=$(curl -s "https://plex.tv/downloads/latest/5?channel=16&build=linux-x86_64&distro=debian" | grep -oE '<a href="([^"#]+)"' | cut -d'"' -f2)

filename=$(basename "$redirect_url")

new_version=$(echo "$filename" | sed -E 's/plexmediaserver_([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+-[0-9a-f]+)_.*$/\1/')

installed_version=$(cat installed_version)

fecha_hora=$(date +"%d/%m/%Y %H:%M")

if [[ "$new_version" != "$installed_version" ]]; then
    echo -e "$fecha_hora La versión actual es $installed_version, se va a proceder a actualizar a la $new_version." >> update_plex.log
    wget https://downloads.plex.tv/plex-media-server-new/${new_version}/debian/plexmediaserver_${new_version}_amd64.deb
    dpkg -i plexmediaserver_${new_version}_amd64.deb
    rm plexmediaserver_${new_version}_amd64.deb
    echo "$new_version" > installed_version
else
    echo -e "$fecha_hora La versión actual es $installed_version, no es necesario actualizar." >> update_plex.log
fi
