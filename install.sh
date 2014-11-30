#!/bin/sh

sudo rm -rf /usr/share/doc
sudo rm -rf /usr/src/vboxguest*
sudo rm -rf /usr/src/virtualbox-ose-guest*
find /var/cache -type f -exec sudo rm -rf {} \;
sudo rm -rf /usr/share/locale/{af,am,ar,as,ast,az,bal,be,bg,bn,bn_IN,br,bs,byn,ca,cr,cs,csb,cy,da,de,de_AT,dz,el,en_AU,en_CA,eo,es,et,et_EE,eu,fa,fi,fo,fr,fur,ga,gez,gl,gu,haw,he,hi,hr,hu,hy,id,is,it,ja,ka,kk,km,kn,ko,kok,ku,ky,lg,lt,lv,mg,mi,mk,ml,mn,mr,ms,mt,nb,ne,nl,nn,no,nso,oc,or,pa,pl,ps,pt,pt_BR,qu,ro,ru,rw,si,sk,sl,so,sq,sr,sr*latin,sv,sw,ta,te,th,ti,tig,tk,tl,tr,tt,ur,urd,ve,vi,wa,wal,wo,xh,zh,zh_HK,zh_CN,zh_TW,zu}

wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
wget -q -O /etc/apt/sources.list.d/mopidy.list http://apt.mopidy.com/mopidy.list

sudo apt-get update

# ZeroConf discovery
# Enables ssh in `ssh pi@raspberrypi.local`
# http://elinux.org/RPi_Advanced_Setup#Setting_up_for_remote_access_.2F_headless_operation
sudo apt-get install avahi-daemon
# sudo insserv avahi-daemon

sudo apt-get install -y mopidy git curl mopidy-alsamixer gstreamer0.10-plugins-good gstreamer0.10-plugins-ugly gstreamer0.10-alsa
sudo adduser mopidy audio
sudo mkdir -p /usr/share/tinyfm/{media,data,playlists}
sudo chown -R mopidy /usr/share/tinyfm/

# Vagrant specific
if [[ $USER = 'vagrant' ]]; then
  sudo addgroup vagrant audio
  sudo cp -f /vagrant/config/mopidy/mopidy.conf /etc/mopidy/mopidy.conf
fi

# Node
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install -y build-essential nodejs

# converter for mp3
# sudo apt-get -y install libav-tools
# sudo apt-get -y install sox libsox-fmt-mp3

# PiFM
cd $HOME
sudo apt-get -y install libsndfile1-dev
git clone https://github.com/ChristopheJacquet/PiFmRds.git
cd PiFmRds/src && make

cd $HOME
git clone https://github.com/tinyfm/mpd2fm.git
cd mpd2fm && npm install

cd $HOME
git clone https://github.com/tinyfm/Client-app.git tinyfm-client-app
cd tinyfm-client-app && npm install && npm run build

# Enable services
sudo mopidyctl local scan
sudo update-rc.d mopidy enable
sudo service mopidy start

