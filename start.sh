#!/bin/bash

# Minecraft server start and watchdog script by Roy Curtis

# #########
# CONFIGURATION:
# #########

# Identity of this server's tmux session (no spaces, please)
IDENT=MCSurvival

# Filename of server jarfile
JAR=spigot-1.8.7.jar

# Arguments for the JVM. Example flags:
# "-XX:+UseParNewGC -XX:+UseConcMarkSweepGC" - Optimizations for modded servers
# "-Dlog4j.configurationFile=log4j.xml" - Overrides for modded server logging
# "-XX:+FlightRecorder -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=1046" - Allows Java Flight recorder debugging
JVM_ARGS="-server -Xms3G -Xmx3G"

# #########
# CONSTANTS:
# #########

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ME=`basename $0`
PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

cd $DIR

# #########
# SCRIPT:
# #########

if [ "$1" = "--watchdog" ]; then
    # Watchdog loop; to debug, call `start.sh watchdog` 
    while true; do
        echo -e "*** Starting ${IDENT} ..."
        java $JVM_ARGS -jar $JAR
        echo -e "*** ${JAR} exited with code $?. Restarting in 5 seconds (or press CTRL+C NOW to exit)..."
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
        echo -e "$IDENT starting under watchdog script. Use 'tmux attach -t ${IDENT}'' for console."
    fi
fi