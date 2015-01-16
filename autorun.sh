#!/bin/sh

# Minecraft server system startup cron script
PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

if [ "$1" != "--cron" ]; then
    echo "*** Please do not use this script directly; use individual start.sh scripts instead"
    echo "*** If you really need to run this script or to put in in cron, do ./autorun.sh --cron"
    exit 1
fi

# Sleep needed to ensure system services have been given a chance to load
sleep 5
/home/minecraft/Survival1.8/start.sh
/home/minecraft/Direwolf20/start.sh