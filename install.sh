#!/usr/bin/env bash

set -euo pipefail

echo "$(tput setaf 4)-----------------------------$(tput sgr0)"
echo "$(tput setaf 4)--- OSO Raspberry install ---$(tput sgr0)"
echo "$(tput setaf 4)-----------------------------$(tput sgr0)"
echo

if [ -z "${AWS_ACCESS_KEY:-}" ]
then
  echo "$(tput setaf 1)Missing AWS_ACCESS_KEY$(tput sgr0)"
  echo "Type $(tput setaf 3)export AWS_ACCESS_KEY=\"AK...\"$(tput sgr0) before running this script"
  exit 1
fi

if [ -z "${AWS_SECRET_KEY:-}" ]
then
  echo "$(tput setaf 1)Missing AWS_SECRET_KEY$(tput sgr0)"
  echo "Type $(tput setaf 3)export AWS_SECRET_KEY=\"zg...\"$(tput sgr0) before running this script"
  exit 1
fi


echo "$(tput setaf 4)--- SEEED microphone driver ---$(tput sgr0)"
cd
git clone --depth 1 https://github.com/respeaker/seeed-voicecard.git
cd seeed-voicecard
sudo ./install.sh


echo "$(tput setaf 4)--- OSO recorder ---$(tput sgr0)" 
sudo apt install --yes python3-pip ffmpeg
pip3 install boto3
pip3 install pydub

cd ~/oso-raspberry
cp oso_record.sh ~/
sed -e "s#AWS_ACCESS_KEY_TO_BE_FILLED#${AWS_ACCESS_KEY}#" upload.py | sed -e "s#AWS_SECRET_KEY_TO_BE_FILLED#${AWS_SECRET_KEY}#" > ~/upload.py
chmod 744 ~/upload.py
sudo cp oso_record.service /lib/systemd/system/
sudo systemctl enable oso_record


echo "$(tput setaf 4)--- LED ---$(tput sgr0)" 
pip3 install pixel_ring gpiozero
cd ~/oso-raspberry
cp oso_led.py ~/
sudo cp oso_led.service /lib/systemd/system/
sudo systemctl enable oso_led
sudo chmod 644 /etc/wpa_supplicant/wpa_supplicant.conf


echo "$(tput setaf 4)--- Presence ---$(tput sgr0)" 
curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt-get install --yes nodejs
cd ~/oso-raspberry
SERIAL=$(cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2)
sed -e "s#SERIAL_ID_TO_BE_FILLED#${SERIAL}#" index.js > ~/index.js
cp package.json ~/
sudo cp oso_presence.service /lib/systemd/system/
cd
npm install
sudo systemctl enable oso_presence


echo "$(tput setaf 2)--- INSTALLATION SUCCESSFULL, REBOOTING ---$(tput sgr0)"

sudo reboot
