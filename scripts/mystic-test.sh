#!/bin/bash

echo 'Retrieving Mystic docker IP'

#get ip address from docker
ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysticbbs)
if [[ $ip == *"Warning:"* ]]; then
  echo "IP could not be inspected"
  exit 0
fi

echo 'Testing Mystic BUSY [timeout 5 seconds]'

# -a = handle binary as text
# -o = only show matches
# -v -v = double verbose to catch all output
# -n = do not try to lookup ip/domain
# 2>/dev/nul = redirect stderr output to avoid "write(stdout): Broken pipe" when server closes connection

result=$(timeout --signal=9 5 bash -c "netcat $ip 23 -v -v -n | grep -m 1 -ao 'BUSY'" 2>/dev/nul)
#result=$(timeout --signal=9 2 bash -c "netcat $ip 22 -v | grep -m 1 -o 'cryptlib'")
#result=$(timeout --signal=9 2 bash -c "netcat $ip 22 -v")
#result=$(timeout --signal=9 40 netcat $ip 23 -v | grep -ao "ASCII" && pkill -9 -f 'netcat $ip 23 -v')
#result=$(timeout --signal=9 2 nc bbs.theforze.eu 22 | grep SSH)
#result=$(timeout --signal=9 2 nc 172.17.0.18 22 | grep SSH)
#result=$(netcat -w 1 -z -v 192.168.2.38 2323 2>&1)
#result=$?
#echo $result

match=$(echo $result | grep -c 'BUSY')
if [ $match -eq 1 ]; then
  echo "Failed, restarting MysticBBS"

  synowebapi --exec api=SYNO.Docker.Container version=1 method=stop name="mysticbbs"
  docker container start mysticbbs
  exit 0
fi

echo "Mystic Not BUSY [sleep 5 seconds]"
sleep 5

echo 'Testing Mystic ASCII connection [timeout 20 seconds]'
#
result=$(timeout --signal=9 20 bash -c "netcat $ip 23 -v -v -n | grep -m 1 -ao 'ASCII'" 2>/dev/null) 
match=$(echo $result | grep -c 'ASCII')
if [ $match -eq 1 ]; then
  echo "Success, no Mystic restart required"
  exit 0
fi

echo "Failed, restarting Mystic"

synowebapi --exec api=SYNO.Docker.Container version=1 method=stop name="mysticbbs"
docker container start mysticbbs
exit 0
