#!/usr/bin/env bash

set -euo pipefail

echo "$(tput setaf 4)--- OSO Raspberry install ---$(tput sgr0)"

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
git clone https://github.com/respeaker/seeed-voicecard.git
cd seeed-voicecard
sudo ./install.sh


echo "$(tput setaf 4)--- local full recorder ---$(tput sgr0)" 
cd ~/oso-raspberry
cp oso_record.sh ~/
sudo cp oso_record.service /lib/systemd/system/
sudo systemctl enable oso_record


echo "$(tput setaf 4)--- S3 uploader ---$(tput sgr0)" 
pip install boto3
pip install pydub
sudo apt install --yes ffmpeg

cd ~/oso-raspberry
cp oso_upload.sh ~/
cat upload.py | sed -e 's/AWS_ACCESS_KEY_TO_BE_FILLED/"${AWS_ACCESS_KEY}"/' | sed -e 's/AWS_SECRET_KEY_TO_BE_FILLED/"${AWS_SECRET_KEY}"/' > ~/upload.py
chmod 744 ~/upload.py
sudo cp oso_upload.service /lib/systemd/system/
sudo systemctl enable oso_upload


echo "$(tput setaf 2)--- INSTALLATION SUCCESSFULL ---$(tput sgr0)"
