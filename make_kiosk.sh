#!/bin/bash

# origin url https://gist.github.com/ThinhPhan/563ca3eaf89aab4a4f30716584aee0b7
sudo apt update && sudo apt upgrade -y

# Create kiosk User Account
sudo adduser kiosk --gecos "Kiosk App,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "kiosk:123456" | sudo chpasswd

# Install Required Packages
# Chromium is the Chrome browser but with much more options.
# Unclutter removes the mouse cursor from the screen, giving it a clean look.
sudo apt-get install -y chromium-browser unclutter

# choose lightdm
sudo apt-get install -y lightdm

# sudo apt install util-linux # rtcwake

# Display Server + Windows Manager
sudo apt install xorg openbox -y

# Setup Auto Login
sudo mkdir -p /etc/lightdm
sudo cp lightdm.conf /etc/lightdm
sudo mkdir -p /etc/lightdm/lightdm.conf.d
sudo cp 50-myconfig.conf /etc/lightdm/lightdm.conf.d

# Setup kiosk.sh Script
sudo mkdir -p /home/kiosk/.config/autostart 
sudo cp kiosk.desktop /home/kiosk/.config/autostart 
sudo chmod +x kiosk.sh
sudo cp kiosk.sh /home/kiosk
sudo chown -R kiosk:kiosk /home/kiosk

sudo cp ./ossystem-logo/ossystem-logo.png /usr/share/plymouth/ubuntu-logo.png
sudo cp -R ./ossystem-logo /usr/share/plymouth/themes/
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/ossystem-logo/ossystem-logo.plymouth 100
# Choose the theme
sudo update-alternatives --config default.plymouth
sudo update-initramfs -u

#To fix the delayed loading of the splash:
sudo -s
echo FRAMEBUFFER=y >>/etc/initramfs-tools/conf.d/splash
update-initramfs -u

# suspend until a known time
sudo cp ./suspend_until.sh /home/kiosk
sudo chmod +x /home/kiosk/suspend_until.sh
crontab -l | { cat; echo "00 20 * * * /home/kiosk/suspend_until.sh 08:00"; } | crontab -

echo "kiosk  ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo