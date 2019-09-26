#!/usr/bin/env bash

set -euo pipefail

DIR=${HOME}/uploads
DURATION=60

mkdir -p "${DIR}"

if [ $(arecord -l | wc -l) -gt 1 ]
then
  while true
  do
    WAV=${DIR}/$(date -u +"%Y-%m-%dT%H:%M:%SZ").wav
    arecord -D sysdefault:CARD=1 -f S16_LE -r 16000 -d ${DURATION} ${WAV}
    ${HOME}/upload.py ${WAV} &
  done
else
  echo "waiting for microphone"
  sleep 5
fi
