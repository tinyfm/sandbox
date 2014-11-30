# FrenchBox Vagrant Image

> Al Jazeera [Canvas hackaton](http://canvas.aljazeera.com) Vagrant box of the *rpi* content.

# Install

Requires *Vagrant* and *VirtualBox*.

```bash
git clone https://github.com/oncletom/frenchbox-vagrant.git
cd frenchbox-vagrant && vagrant up
```

# Usage

An Web server should be running on `localhost:6680`.

The content of the tracklist can be displayed with a small Node script:

```bash
npm install

HOST=localhost node src/display-tracks.js
```

# Raspberry Pi

```bash
ssh pi@raspberrypi.local
```