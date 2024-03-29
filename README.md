# oso-raspberry

Configuration scripts for OSO raspberry

Procédure semi-manuelle, à complètement automatiser à terme (cf [pi-gen](https://github.com/RPi-Distro/pi-gen)).

# Raspbian

En partant d’une carte SD vierge, suivre les instructions sur le [site de rapsberry](https://www.raspberrypi.org/documentation/installation/installing-images/README.md).

Dans la partie téléchargement, choisir Raspbian, puis [télécharger Raspbian Buster Lite](https://www.raspberrypi.org/downloads/raspbian/). Le fichier récupéré est `2019-07-10-raspbian-buster-lite.zip`

Décompresser puis copier l’image sur la carte SD en suivant les instructions.

# Activer SSH

Avant de mettre la carte SD dans le RPi, créer un fichier vide nommé `ssh` à la racine de la carte SD.

```bash
cd boot
touch ssh
```

## Connexion via cable ethernet

Configurer si besoin l'ordinateur portable [TODO]. Brancher un cable ethernet entre le portable et le Pi. Allumer le Pi.

```
ssh pi@raspberrypi.local
```

Mot de passe `raspberry`

## Connexion via le réseau

Avant de mettre la carte SD dans le RPi, créer un fichier `wpa_supplicant.conf` avec le nom et le mot de passe du réseau wifi. Voir [les instructions](https://www.raspberrypi.org/documentation/configuration/wireless/headless.md).

```bash
cd boot
cat > wpa_supplicant.conf
```

Adapter le SSID et le mot de passe :

```bash
country=fr
update_config=1
ctrl_interface=/var/run/wpa_supplicant

network={
 ssid="YOUR_SSID"
 psk="YOUR_PASSWORD"
}
```

Éjecter la carte, la mettre dans le Pi et le brancher. Après ~20 secondes, le Pi devrait être connecté au réseau Wifi local. Aller sur la page de gestion du réseau sur votre routeur, et trouver l’adresse locale du RPi. Elle doit être de la forme 192.168.xxx.xxx

Depuis un ordinateur connecté à ce même réseau, se connecter en ssh sur le RPi :

`ssh pi@192.168.xxx.xxx`

Mot de passe `raspberry`

# Installation

Une fois connecté en ssh au Pi, copier ces commandes dans le terminal, en renseignant les clefs AWS manquantes :

```
sudo dpkg-reconfigure tzdata

sudo apt-get update
sudo apt-get --yes upgrade

sudo apt-get install --yes git

git clone --depth 1 https://github.com/GillesDebunne/oso-raspberry.git

export AWS_ACCESS_KEY="AK................3S"
export AWS_SECRET_KEY="zg....................................cT"

oso-raspberry/install.sh
```

# Configuration

Dans l'EHPAD, démarrer le pi branché sur un écran, avec clavier et souris. S'y connecter et régler le Wifi en tapant `sudo raspi-config`. Choisir l'option `2 Network Options`, puis `N2 Wi-fi`, et suivre les instructions.

# Install Mac Gilles

Cf `flashSDMac.sh`

Activer 'Internet sharing' dans les Préférences Système, 'on' 'Apple USB Ethernet Adapter' pour que le Pi utilise la connexion internet du Mac.
