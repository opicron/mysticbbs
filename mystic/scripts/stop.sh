#!/bin/bash
#==================================================================================================
# This shell script will stop the mystic internet service (mis). It will fail out if the process  #
# is not running and a stop attempt is made. It will also continually poll to make sure it stops  #
# successfully, and if it is still running after 60 seconds, will be forcefully terminated. This  #
# script can ideally be called as a fork within a systemd .service file. The script will exit     #
# with an appropriate error code to indicate whether is was successful or not. It is intended to  #
# work only with Debian, Ubuntu and other debian based distributions.                             #
#                                                                                                 #
# For more information visit: https://vswitchzero.com/mystic-systemd                              #
#==================================================================================================

# Some variables. The MIS_OPTS should contain the daemon option (-d in older versions). The 
# MIS_SHUT_OPTS should be the shutdown option ('shutdown' in newer versions). Ensure your mystic 
# path is set correctly.

MIS_PATH=/mystic/src
MIS_OPTS=daemon
MIS_SHUT_OPTS=shutdown
MIS_PID=$(ps auxwww | grep "mis $MIS_OPTS" | grep -v grep | awk '{print $2}')

echo "Attempting to stop the Mystic Internet Service daemon.."

# Make sure mis is running, otherwise exit:
if [ -z "$MIS_PID" ]
then
    echo "Error: Can't stop the MIS daemon as it is not running."
    exit 1
else
    echo "MIS daemon is currently running with PID $MIS_PID. Stopping.."
fi

# If the script gets to this point, it should be safe to stop the mis daemon. The script first changes
# directory to the mystic path specified just in case the "mysticbbs" environment variable is not set.
cd $MIS_PATH > /dev/null
$MIS_PATH/mis $MIS_SHUT_OPTS
cd - > /dev/null

MIS_COUNTER=0
echo "Checking to ensure the process stops.."

while [ $MIS_COUNTER -lt 12 ]; do
    MIS_PID=$(ps auxwww | grep "mis $MIS_OPTS" | grep -v grep | awk '{print $2}')
    if [ ! -z "$MIS_PID" ]
    then
        echo "MIS process still running. Waiting 5 seconds.."
        sleep 5
    else
        echo "Finished! MIS daemon has been stopped successfully."
        exit 0
    fi
    let MIS_COUNTER=MIS_COUNTER+1 
done

# If it's still running after 60 seconds (12 intervals) then an error is displayed.
if [ "$MIS_COUNTER" -eq 12 ] && [ ! -z "$MIS_PID" ]
then
    echo "Error: Process failed to stop gracefully after 60 seconds."
fi

# Uncomment the code between the dashes if you want the script to forcefully kill the process if it 
# doesn't go down gracefully. Please note that this is potentially risky, and will only be done if 
# the mis.bsy semaphore has already been removed. Use this section at your own risk, but it can 
# help to address common process termination issues.
#
#--------------------------------------------------------------------------------------------------
# MIS_PID=$(ps auxwww | grep "mis $MIS_OPTS" | grep -v grep | awk '{print $2}')
# if [ ! -z "$MIS_PID" ] && [ ! -f "$MIS_PATH/semaphore/mis.bsy" ]
# then
#    echo "Stopping process forcefully using kill -9 because the mis.bsy semaphore was already removed"
#    kill -9 $MIS_PID
#    sleep 5
#    MIS_PID=$(ps auxwww | grep "mis $MIS_OPTS" | grep -v grep | awk '{print $2}')
#    if [ ! -z "$MIS_PID" ]
#    then
#        echo "Error: MIS daemon forceful stop failed."
#        exit 1
#    else
#        echo "Success. MIS daemon was forcefully stopped."
#        exit 0
#    fi
# fi
#--------------------------------------------------------------------------------------------------

exit 1
