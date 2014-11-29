#!/bin/sh

sudo rm -rf /usr/share/doc
sudo rm -rf /usr/src/vboxguest*
sudo rm -rf /usr/src/virtualbox-ose-guest*
find /var/cache -type f -exec sudo rm -rf {} \;
sudo rm -rf /usr/share/locale/{af,am,ar,as,ast,az,bal,be,bg,bn,bn_IN,br,bs,byn,ca,cr,cs,csb,cy,da,de,de_AT,dz,el,en_AU,en_CA,eo,es,et,et_EE,eu,fa,fi,fo,fr,fur,ga,gez,gl,gu,haw,he,hi,hr,hu,hy,id,is,it,ja,ka,kk,km,kn,ko,kok,ku,ky,lg,lt,lv,mg,mi,mk,ml,mn,mr,ms,mt,nb,ne,nl,nn,no,nso,oc,or,pa,pl,ps,pt,pt_BR,qu,ro,ru,rw,si,sk,sl,so,sq,sr,sr*latin,sv,sw,ta,te,th,ti,tig,tk,tl,tr,tt,ur,urd,ve,vi,wa,wal,wo,xh,zh,zh_HK,zh_CN,zh_TW,zu}

wget -q -O - https://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
wget -q -O /etc/apt/sources.list.d/mopidy.list http://apt.mopidy.com/mopidy.list
sudo apt-get update

sudo apt-get install -y mopidy mopidy-alsamixer gstreamer0.10-plugins-ugly xdg-user-dirs git curl

# Node
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install -y build-essential nodejs

# UI
git clone git://github.com/meantimeit/jukepi.git && cd jukepi && git submodule update --init --recursive
cp jukepi/build/index.html.sample jukepi/build/index.html
