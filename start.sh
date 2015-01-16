#!/bin/sh

# Minecraft server start and watchdog script by Roy Curtis

# #########
# CONFIGURATION:
# #########

# Identity of this server's tmux session (no spaces, please)
IDENT=MCSurvival

# Filename of server jarfile
JAR=spigot.jar

# Arguments for the JVM
JVM_ARGS="-Xms3G -Xmx3G -XX:MaxPermSize=256M"

# #########
# CONSTANTS:
# #########

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ME=`basename $0`
PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
RED="\033[0;31m"
PURPLE="\033[0;35m"
BLUE="\033[0;36m"
CRESET="\033[0m"

cd $DIR

# #########
# SCRIPT:
# #########

if [ "$1" = "--watchdog" ]; then
    # Watchdog loop; to debug, call `start.sh watchdog` 
    while true; do
        echo -e "*** Starting ${PURPLE}${IDENT}${CRESET} ..."
        java $JVM_ARGS -jar $JAR
        echo -e "*** ${PURPLE}${JAR}${CRESET} exited with code $?. Restarting in 5 seconds (or press CTRL+C NOW to exit)..."
        sleep 5
    done
else
    # Ignition
    tmux has-session -t $IDENT 2> /dev/null
    if [ "$?" -eq "0" ]; then
        echo -e "$IDENT is already running under a tmux session (have you tried 'tmux attach -t ${IDENT}'?)"
        exit 1
    else
        tmux new -d -s $IDENT "$DIR/$ME --watchdog"
        echo -e "$IDENT starting under watchdog script. Use ${BLUE}tmux attach -t ${IDENT}${CRESET} for console."
    fi
fi