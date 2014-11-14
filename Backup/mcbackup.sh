#!/bin/sh

# Minecraft server directory on-demand and crontab backup script by Roy Curtis

# #########
# CONFIGURATION:
# #########

# Backups directory, RELATIVE to this script's path
BACKUPDIR=backups

# Exclude file, RELATIVE to this script's path
EXCLUDEFILE=mcbackup.exclude

# Maximum number of days to keep backups
MAXDAYS=30

# #########
# CONSTANTS:
# #########

TARGET=${1%/}
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ME=`basename $0`
PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
RED="\033[0;31m"
PURPLE="\033[0;35m"
BLUE="\033[0;36m"
CRESET="\033[0m"

cd $DIR

# #########
# HELP:
# #########
function help
{
   echo -e "./mcbackup.sh [--cron [--dry]|--clean|<dirname>]"
   echo -e "* --cron: Calls itself multiple times, one for each server defined in the script"
   echo -e "* --cron --dry: Dry-run of --cron (no backups made)"
   echo -e "* --clean: Deletes all backups older than $MAXDAYS days"
   echo -e "* <dirname>: Does timestamped and compressed backup of directory in ${BLUE}${DIR}/${BACKUPDIR}${CRESET}. No trailing slashes."
   echo -e " "
   echo -e "Example: ./mcbackup.sh Survival1.8"
   echo -e "Open this script with text editor of choice to change settings"
}

# #########
# SCRIPT:
# #########

# === Crontab multi-backup ===
if [[ "$1" = "--help" || "$1" = "-h" || "$1" = "-?" ]]; then
    help
    exit 0
fi

# === Crontab multi-backup ===
if [ "$1" = "--cron" ]; then
    echo -e "*** Performing periodic Minecraft servers backup at ${BLUE}${DIR}/${BACKUPDIR}${CRESET}..."
    if [ "$2" != "--dry" ]; then
        ./$ME Survival1.8
        ./$ME Direwolf20
    fi
    echo -e "*** Periodic backup of Minecraft servers done"
    exit 0
fi

# === Crontab clean ===
if [ "$1" = "--clean" ]; then
    # Backup cleaning (for crontab use)
    echo -e "*** Cleaning ${MAXDAYS}+ day old Minecraft backups at ${BLUE}${DIR}/${BACKUPDIR}${CRESET}..."
    find $BACKUPDIR -type f -name "*.tar.bz" -mtime +$MAXDAYS -delete
    echo -e "*** Periodic Minecraft server backup cleanup done"
    exit 0
fi

# === Main backup routine ===
if [[ -z "$TARGET" || ! -d "$TARGET" ]]; then
    echo -e "*** ${RED}Please specify the directory to backup${CRESET}"
    help
    exit 1
fi

echo -e "*** Calculating backup size..."

TIMESTAMP=`date +%H%M-%d-%m-%Y`
BACKUPPATH=$BACKUPDIR/$TARGET-$TIMESTAMP.tar.bz
SIZE=`du -sm --exclude-from=$EXCLUDEFILE "$TARGET" 2> /dev/null | cut -f 1`

echo -e "*** Performing ${BLUE}${SIZE}MB${CRESET} $DIR/$TARGET backup to ${BLUE}${BACKUPPATH}${CRESET}..."
if [ "$2" != "--dry" ]
then
    tar \
        --exclude-from=$EXCLUDEFILE \
        -cf - "$TARGET" | pv -p -e -r -b -s ${SIZE}m | bzip2 -c > $BACKUPPATH
fi
echo -e "*** Finished backup to ${BLUE}${BACKUPPATH}${CRESET}"