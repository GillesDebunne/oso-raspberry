#/bin/bash

DIR=${HOME}/records

mkdir -p "${DIR}"

while true
do
  if [ $(arecord -l | wc -l) -gt 1 ]
  then
    arecord -D sysdefault:CARD=1 -f S32_LE -r 16000 ${DIR}/record_$(date -u +"%Y-%m-%dT%H:%M:%SZ").wav
    break
  else
    echo "waiting for microphone"
    sleep 5
  fi
done
