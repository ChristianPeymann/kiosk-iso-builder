#!/bin/bash

clear
echo -e "\e[1;32m"
echo " █████╗  ██████╗  ██╗  ██╗ "
echo "██╔══██╗ ██╔══██╗ ██║ ██╔╝ "
echo "███████║ ██████╔╝ █████╔╝  "
echo "██╔══██║ ██╔══██╗ ██╔═██╗  "
echo "██║  ██║ ██║  ██║ ██║  ██╗ "
echo "╚═╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝ "
echo ""
echo -e "\e[1;36m>>> A.R.K. : ARCH REMOTE KIOSK <<<\e[1;32m"
echo ""
echo ">>> SYSTEM INITIALIZATION PROTOCOL"
echo ">>> TARGET SECTOR: /dev/mmcblk0"
echo "======================================="
echo "      crafted by Christian Peymann     "
echo "======================================="
echo -e "\e[0m"
echo -e "\e[5;31m[WARNING] CRITICAL SYSTEM OVERRIDE IN 60 SECONDS\e[0m"
echo ""
echo "Execute deployment sequence? Press (Y)es or (N)o"

read -t 60 -n 1 -s key

if [[ $key == "n" || $key == "N" ]]; then
    echo -e "\n\e[1;31m[!] DEPLOYMENT ABORTED.\e[0m"
    exit 0
fi

echo -e "\n\e[1;32m[+] INITIATING CORE INSTALLATION...\e[0m"

sgdisk -Z /dev/mmcblk0
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI" /dev/mmcblk0
sgdisk -n 2:0:0 -t 2:8300 -c 2:"ROOT" /dev/mmcblk0

mkfs.fat -F32 /dev/mmcblk0p1
mkfs.ext4 -F /dev/mmcblk0p2

mount /dev/mmcblk0p2 /mnt
mkdir -p /mnt/boot
mount /dev/mmcblk0p1 /mnt/boot

pacstrap /mnt base linux linux-firmware networkmanager openssh xorg-server chromium openbox rsync cifs-utils

genfstab -U /mnt >> /mnt/etc/fstab

# Deutsche Zeitzone setzen
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
arch-chroot /mnt hwclock --systohc

# Deutsche Sprache aktivieren
sed -i 's/^#de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=de_DE.UTF-8" > /mnt/etc/locale.conf

# Deutsches Tastaturlayout fuer die Konsole
echo "KEYMAP=de-latin1" > /mnt/etc/vconsole.conf

# Deutsches Tastaturlayout fuer die grafische Oberflaeche
mkdir -p /mnt/etc/X11/xorg.conf.d
cat << 'EOF' > /mnt/etc/X11/xorg.conf.d/00-keyboard.conf
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "de"
    Option "XkbVariant" "nodeadkeys"
EndSection
EOF

arch-chroot /mnt systemctl enable NetworkManager sshd

echo -e "\n\e[1;32m[+] DEPLOYMENT SUCCESSFUL. REMOVE MEDIA AND REBOOT.\e[0m"