#/bin/bash

set -euxo pipefail

echo "$(tput setaf 4)--- OSO Raspberry install ---$(tput sgr0)"

cd

git clone https://github.com/respeaker/seeed-voicecard.git
cd seeed-voicecard
sudo ./install.sh

cd ~/oso-raspberry

cp oso_record.sh ~/
sudo cp oso_record.service /lib/systemd/system/
sudo systemctl enable oso_record


echo "$(tput setaf 2)--- INSTALLATION SUCCESSFULL ---$(tput sgr0)"
