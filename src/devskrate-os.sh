#Packages required to build OS in your system.
sudo apt install live-build
sudo apt install xorriso

mkdir mylive-test
cd mylive-test

#We Used Buster as Base OS, you can use any updated stable Debian version. If you try to use Testing or SID, you may face issues with sources, but you can fix them.
lb config -d buster


touch auto/config

#Add the configuration required for  your system.
echo "#!/bin/bash

set -e


#add your mirror
mirror="http://127.0.0.1:3142/debianmirror.nkn.in/debian"
dist="buster"

lb config noauto \
     --architectures amd64 \
     --archive-areas "main contrib non-free" \
     --interactive shell \
     --debian-installer true  \
     --debian-installer-gui true \
     --mirror-bootstrap "$mirror" \
     --mirror-debian-installer "$mirror" \
     --distribution "$dist" \
     --debian-installer-distribution "$dist" \
     --iso-application "devskrate" \
     --iso-publisher "mvs" \
     --iso-volume "devskrate live" \
     --security false \
     --updates true \
     --memtest memtest86 \
	"${@}"
" >> auto/config


#Packages that you want to include in the OS.
echo "task-xfce-desktop
calamares
calamares-settings-debian
debian-installer-launcher
iputils-ping
gparted
lvm2
htop
sudo
net-tools
cryptsetup
encfs
gpg
gnupg
curl
ufw
openssh-server
software-properties-common
apt-transport-https
build-essential
devscripts
wget
vim
python3-pip
" >> config/package-lists/devskrate-packages.list.chroot

#If you want to include softwares that are not in the debian repositories, then download the file and place it in the below directory manually.
mkdir config/includes.chroot/opt/

#For starting building the OS and build.log is for saving the logs for future use.
sudo lb build 2>&1 | tee build.log

