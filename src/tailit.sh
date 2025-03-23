#!/bin/bash

# Define the total number of node
num_nodes=7

# Loop through each node
for i in $(seq 1 $num_nodes); do

  # Files
  log_file="/mystic/logs/node${i}.log"
  login_file="/mystic/temp${i}/login.n${i}"
  
  # Log node
  tail -n0 -F "$log_file" | grep --line-buffered -Evf /mystic/grep_log_blacklist.txt | while IFS= read -r line; do
    if [ -r "$login_file" ]; then
      prefix="$(head -n 1 "$login_file"): "
    else
      prefix=""
    fi
    echo "${prefix}${line}" >> /mystic/logs/nodes.log
    escaped_line=$(echo "$line" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')
    curl -s -o /dev/null -X POST -H "Content-type: application/json" --data "{\"text\":\"${prefix}${escaped_line}\"}" https://hooks.slack.com/services/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
  done &
done

# Log errors
tail -n0 -F /mystic/logs/errors.log | grep --line-buffered -Evf /mystic/grep_log_blacklist.txt | while IFS= read -r line; do
    #prefix="--[ERROR]--"
    #postfix="--[END]--"
    #echo "${prefix}" >> /mystic/logs/nodes.log
    echo "${line}" >> /mystic/logs/nodes.log
    #echo "${postfix}" >> /mystic/logs/nodes.log
    escaped_line=$(echo "$line" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')
    curl -s -o /dev/null -X POST -H "Content-type: application/json" --data "{'text':\"${escaped_line}\"}" https://hooks.slack.com/services/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
done &

# Log mis
tail -n0 -F /mystic/logs/mis.log | grep --line-buffered -Evf /mystic/grep_log_blacklist.txt | while IFS= read -r line; do
    #prefix="--[ERROR]--"
    #postfix="--[END]--"
    #echo "${prefix}" >> /mystic/logs/nodes.log
    echo "${line}" >> /mystic/logs/nodes.log
    #echo "${postfix}" >> /mystic/logs/nodes.log
    escaped_line=$(echo "$line" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g')
    curl -s -o /dev/null -X POST -H "Content-type: application/json" --data "{\"text\":\"${prefix}${escaped_line}\"}" https://hooks.slack.com/services/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
done &

# Log everything to docker
tail -n0 -F /mystic/logs/nodes.log >> /proc/1/fd/1 &
