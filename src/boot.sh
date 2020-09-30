#!/usr/bin/env bash
# Mystic BBS docker boot script
#exec /mystic/start.sh
exec su - root -c 'cd /mystic && /mystic/mis daemon'
