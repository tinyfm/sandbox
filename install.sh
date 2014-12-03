#!/bin/sh

cd $HOME

# Additional sources
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y apt-transport-https

wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
wget -q -O - http://apt.mopidy.com/mopidy.list | sudo tee /etc/apt/sources.list.d/mopidy.list

#
sudo apt-get update

# ZeroConf discovery
# Enables ssh in `ssh pi@raspberrypi.local`
# http://elinux.org/RPi_Advanced_Setup#Setting_up_for_remote_access_.2F_headless_operation
sudo apt-get install -y avahi-daemon
if [[ -x /sbin/insserv ]]; then
  sudo insserv avahi-daemon
fi

# Mopidy install
sudo apt-get install -y mopidy git curl mopidy-alsamixer
sudo adduser mopidy audio
sudo mkdir -p /usr/share/tinyfm/{media,data,playlists}
sudo chown -R mopidy /usr/share/tinyfm/

# Vagrant specific
if [[ $USER = 'vagrant' ]]; then
  sudo addgroup vagrant audio
  sudo cp -f /vagrant/config/mopidy/mopidy.conf /etc/mopidy/mopidy.conf
else
  wget -q -O - https://raw.githubusercontent.com/tinyfm/sandbox/master/config/mopidy/mopidy.conf | sudo tee /etc/mopidy/mopidy.conf
fi

# Node.js
wget https://node-arm.herokuapp.com/node_latest_armhf.deb
sudo dpkg -i node_latest_armhf.deb && rm node_latest_armhf.deb


# Audio conversion tools
sudo apt-get -y install sox libsox-fmt-mp3

# PiFM
cd $HOME
sudo apt-get -y install libsndfile1-dev
git clone https://github.com/ChristopheJacquet/PiFmRds.git
cd PiFmRds/src && make

# mpd2fm
cd $HOME
git clone https://github.com/tinyfm/mpd2fm.git
cd mpd2fm && npm install

sudo cp -f $HOME/mpd2fm/dist/init.d/mpd2fm /etc/init.d/mpd2fm
sudo chmod a+x /etc/init.d/mpd2fm
sudo update-rc.d mpd2fm defaults

# Client-app
cd $HOME
git clone https://github.com/tinyfm/Client-app.git tinyfm-client-app
cd tinyfm-client-app && npm install && npm run build

# Enable services
sudo mopidyctl local scan
sudo update-rc.d mopidy enable
sudo service mopidy start

