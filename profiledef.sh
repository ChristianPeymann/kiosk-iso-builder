#!/usr/bin/env bash
iso_name="ark_os"
iso_label="ARK_BETA"
iso_publisher="Christian Peymann"
iso_application="A.R.K. : Arch Remote Kiosk Live Beta"
iso_version="0.1_beta"
install_dir="arch"
buildmodes=('iso')
bootmodes=('uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="erofs"
airootfs_image_tool_options=('-zlz4hc,12' -E ztailpacking)
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.bash_profile"]="0:0:755"
  ["/root/auto_install.sh"]="0:0:755"
)