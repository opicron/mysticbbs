#!/bin/bash
#set -e

#Define cleanup procedure
cleanup() {
    echo "Container stopped, performing cleanup..."
    /mystic/stop.sh
}

#Trap SIGTERM
trap 'cleanup' SIGTERM

if [ "$1" = 'mystic' ]
then
    #chown -R postgres "$PGDATA"

    #if [ -z "$(ls -A "$PGDATA")" ]; then
    #    gosu postgres initdb
    #fi
    cron
    rm /mystic/semaphore/mis.bsy
    /mystic/mis daemon
    #/mystic/start.sh
    
    tail -f /mystic/logs/mis.log
    #while true
    #  do sleep 50000
    #done
    
    #/mystic/mis 
    #exec su - root -c 'cd /mystic && /mystic/mis daemon'
else
    exec "$@"
fi

#Wait
wait $!

# Mystic BBS docker boot script
#exec /mystic/start.sh
#exec su - root -c 'cd /mystic && /mystic/mis daemon'
