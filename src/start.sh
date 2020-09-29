#!/bin/bash
#==================================================================================================
# This shell script will start the mystic internet service (mis). It checks to see if a stale     #
# semaphore is left behind and will also error out if the process is already running and          #
# a start attempt is made. This script can ideally be called as a fork within a systemd .service  #
# file. The script will exit with an appropriate error code to indicate whether is was successful #
# or not. It is intended to work only with Debian, Ubuntu and other debian based distributions.   #
#                                                                                                 #
# For more information visit: https://vswitchzero.com/mystic-systemd                              #
#==================================================================================================

# Some variables. Older versions of mystic used -d instead of daemon as an option, so change
# accordingly. Also ensure your mystic path is set correctly.
MIS_PATH=/mystic
MIS_OPTS=server
MIS_PID=$(ps auxwww | grep "mis $MIS_OPTS" | grep -v grep | awk '{print $2}')

echo "Attempting to start the Mystic Internet Service (mis).."

# Make sure mis isn't already running:
if [ ! -z "$MIS_PID" ]
then
    echo "mis-start.sh: Error: mis daemon is already running with PID $MIS_PID. Stop the service before attempting to start it."
    exit 1
fi

# If the process isn't running there shouldn't be a mis.bsy file in the semaphore directory.
# Sometimes it's left behind if the process doesn't stop cleanly. This is not uncommon. The
# file is removed if the proces is not running and the file exists. Otherwise the service will
# fail to start.

if [ -f "$MIS_PATH/semaphore/mis.bsy" ] && [ -z "$MIS_PID" ]
then
    echo "Warning: The mis.bsy semaphore exists even though the mis daemon is not running."
    echo "Removing semaphore.."
    rm $MIS_PATH/semaphore/mis.bsy
    if [ -f "$MIS_PATH/semaphore/mis.bsy" ]
    then
        echo "Error: Failed to remove semaphore. Service cannot start while semaphore exists. Exiting."
        exit 1
    else
        echo "Semaphore successfully removed. Proceeding to start the mis daemon.."
    fi
else
    echo "No stale semaphore file found. Proceeding to start the mis daemon.."
fi

# If the script gets to this point, it should be safe to start the mis daemon. The script first changes
# directory to the mystic path specified just in case the "mysticbbs" environment variable is not set.
cd $MIS_PATH > /dev/null
$MIS_PATH/mis $MIS_OPTS
cd - > /dev/null

#Keep checking to make sure the service starts:
MIS_COUNTER=0
echo "Checking to ensure the process starts.."

while [ $MIS_COUNTER -lt 6 ]
do
    MIS_PID=$(ps auxwww | grep "mis $MIS_OPTS" | grep -v grep | awk '{print $2}')
    if [ -z "$MIS_PID" ]
    then
        echo "Process has not yet started. Waiting 5 seconds.."
        sleep 5
    else
        echo "Finished! Mis daemon has been started successfully at PID $MIS_PID."
        exit 0
    fi
    let MIS_COUNTER=MIS_COUNTER+1 
done

# If it's still not up after 30 seconds we consider this a failure.
if [ "$MIS_COUNTER" -eq 6 ] && [ -z "$MIS_PID" ]
then
    echo "Error: Process failed to start after 30 seconds."
    exit 1
fi
