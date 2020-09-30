#!/bin/bash
#set -e

if [ "$1" = 'mystic' ]; then
    #chown -R postgres "$PGDATA"

    #if [ -z "$(ls -A "$PGDATA")" ]; then
    #    gosu postgres initdb
    #fi

    exec su - root -c 'cd /mystic && /mystic/mis daemon'
fi

exec "$@"


# Mystic BBS docker boot script
#exec /mystic/start.sh
#exec su - root -c 'cd /mystic && /mystic/mis daemon'
