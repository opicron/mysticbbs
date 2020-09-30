#!/bin/bash
#set -e

if [ "$1" = 'mystic' ]; then
    #chown -R postgres "$PGDATA"

    #if [ -z "$(ls -A "$PGDATA")" ]; then
    #    gosu postgres initdb
    #fi
    exec /mystic/mis daemon
    #/mystic/start.sh
    
    while true
      do sleep 50000
    done
    
    #/mystic/mis 
    #exec su - root -c 'cd /mystic && /mystic/mis daemon'
fi

exec "$@"


# Mystic BBS docker boot script
#exec /mystic/start.sh
#exec su - root -c 'cd /mystic && /mystic/mis daemon'
