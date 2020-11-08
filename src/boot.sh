#!/bin/bash
#set -e

# Mystic BBS docker boot script

#Define cleanup procedure
cleanup() {
    echo "Container stopped, performing cleanup..." >> /mystic/logs/mis.log
    #the stop script is not required-- just for safety
    /mystic/stop.sh
}

#Trap SIGTERM
trap 'cleanup' SIGTERM

if [ "$1" = 'mystic' ]; then

    # run cron for fido polling
    cron
    
    # remove temp file 
    rm /mystic/semaphore/mis.bsy
    
    # run as server on background
    /mystic/mis server &
    
    # catch PID
    child=$!

    # removed due to correct handling of sigterm
    #tail -f /mystic/logs/mis.log
else
    exec "$@" &
fi

# Wait for server PID
wait "$child"
