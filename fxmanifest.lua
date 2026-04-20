fx_version "cerulean"
game "rdr3"

lua54 "yes"

name "vorp_backpack_inventory"
author "DizzyxScience"
description "Clean backpack-style inventory UI for VORP "
version "1.0.0"

ui_page "ui/index.html"

shared_scripts {
    "shared/config.lua"
}

client_scripts {
    "client/client.lua"
}

server_scripts {
    "server/server.lua"
}

files {
    "ui/index.html",
    "ui/style.css",
    "ui/app.js"
}
