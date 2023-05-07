#!/usr/bin/env bash
# Modified from https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/Root%20on%20ZFS.html under CC BY-SA 3.0
#
# Set up 2 disks with ZFS in RAIDZ1, root on tmpfs, and 2Gb EFI, 4Gb /boot and 4Gb swap per disk.
# Set up 15% of overall disk size as reservation, to prevent a too full zpool.

# check if run as root
if [[ $EUID > 0 ]]
    then echo "Please run as root"
    exit
fi

# Find disks with `find /dev/disk/by-id`
DISKS='/dev/disk/by-id/ata-TOSHIBA_MG08ACA16TE_2140A0MCFVGG /dev/disk/by-id/ata-TOSHIBA_MG08ACA16TE_2140A1CBFVGG'

# Create future mount point.
MNT=$(mktemp -d)

# in GB
SWAPSIZE=4

# Keep some space free at end of disks (why?).
# in GB
RESERVE=1

echo
echo "####################################"
echo "# create (temporary) root password #"
echo "####################################"
echo

#rootPwd=$(mkpasswd -m SHA-512)

# Enable Nix Flakes functionality.
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Install programs needed for system installation
if ! command -v git; then nix-env -f '<nixpkgs>' -iA git; fi
if ! command -v jq; then nix-env -f '<nixpkgs>' -iA jq; fi
if ! command -v partprobe; then nix-env -f '<nixpkgs>' -iA parted; fi

partition_disk () {
 local disk="${1}"
 #blkdiscard  # Uncomment if using flash based storage.

 parted --script --align=optimal "${disk}" -- \
 mklabel gpt \
 mkpart EFI 2MiB 1GiB \
 mkpart boot 1GiB 5GiB \
 mkpart rpool 5GiB -$((SWAPSIZE + RESERVE))GiB \
 mkpart swap -$((SWAPSIZE + RESERVE))GiB -"${RESERVE}"GiB \
 mkpart BIOS 1MiB 2MiB \
 set 1 esp on \
 set 5 bios_grub on \
 set 5 legacy_boot on

 partprobe "${disk}"
 udevadm settle
}

echo
echo "####################"
echo "# formatting disks #"
echo "####################"
echo

for i in ${DISKS}; do
   partition_disk "${i}"
done

echo
echo "###################"
echo "# setting up swap #"
echo "###################"
echo

for i in ${DISKS}; do
   cryptsetup open --type plain --key-file /dev/random "${i}"-part4 "${i##*/}"-part4
   mkswap /dev/mapper/"${i##*/}"-part4
   swapon /dev/mapper/"${i##*/}"-part4
done

echo
echo "#########################"
echo "# create boot partition #"
echo "#########################"
echo

for i in ${DISKS}; do
  mkfs.ext4 "${i}-part2"
done

## shellcheck disable=SC2046
#zpool create \
#    -o compatibility=grub2 \
#    -o ashift=12 \
#    -o autotrim=on \
#    -O acltype=posixacl \
#    -O canmount=off \
#    -O compression=lz4 \
#    -O devices=off \
#    -O normalization=formD \
#    -O relatime=on \
#    -O xattr=sa \
#    -O mountpoint=/boot \
#    -R "${MNT}" \
#    bpool \
#  mirror \
#    $(for i in ${DISKS}; do
#       printf '%s ' "${i}-part2";
#      done)

echo
echo "####################"
echo "# create root pool #"
echo "####################"
echo

# shellcheck disable=SC2046
zpool create \
    -o ashift=12 \
    -o autotrim=on \
    -R "${MNT}" \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=zstd \
    -O dnodesize=auto \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=/ \
    rpool \
    raidz1 \
    $(for i in ${DISKS}; do
      printf '%s ' "${i}-part3";
      done)

echo
echo "###########################"
echo "# create system container #"
echo "###########################"
echo

zfs create \
  -o canmount=off \
  -o mountpoint=none \
  rpool/nixos

echo
echo "##########################"
echo "# create system datasets #"
echo "##########################"
echo

# root
zfs create -o mountpoint=legacy rpool/nixos/root
mount -t zfs rpool/nixos/root "${MNT}"/

# home
zfs create -o mountpoint=legacy rpool/nixos/home
mkdir "${MNT}"/home
mount -t zfs rpool/nixos/home "${MNT}"/home

# nix
zfs create -o mountpoint=legacy rpool/nixos/nix
mkdir "${MNT}"/nix
mount -t zfs rpool/nixos/nix "${MNT}"/nix

# persist
zfs create -o mountpoint=legacy rpool/nixos/persist
mkdir "${MNT}"/persist
mount -t zfs rpool/nixos/persist "${MNT}"/persist

# var
zfs create -o mountpoint=legacy rpool/nixos/var

# var/lib
zfs create -o mountpoint=legacy rpool/nixos/var/lib
mkdir -p "${MNT}"/var/lib
mount -t zfs rpool/nixos/var/lib "${MNT}"/var/lib

# var/log
zfs create -o mountpoint=legacy rpool/nixos/var/log
mkdir -p "${MNT}"/var/log
mount -t zfs rpool/nixos/var/log "${MNT}"/var/log

## boot
#zfs create -o mountpoint=none bpool/nixos
#zfs create -o mountpoint=legacy bpool/nixos/root
mkdir "${MNT}"/boot
mount -t ext4 "${DISKS[0]}-part2" "${MNT}"/boot

echo
echo "########################"
echo "# format and mount ESP #"
echo "########################"
echo

for i in ${DISKS}; do
 mkfs.vfat -n EFI "${i}"-part1
 mkdir -p "${MNT}"/boot/efis/"${i##*/}"-part1
 mount -t vfat -o iocharset=iso8859-1 "${i}"-part1 "${MNT}"/boot/efis/"${i##*/}"-part1
done

#echo
#echo "###############################"
#echo "# clone flake template config #"
#echo "###############################"
#echo
#
#mkdir -p "${MNT}"/etc
#git clone --depth 1 --branch openzfs-guide \
#  https://github.com/ne9z/dotfiles-flake.git "${MNT}"/etc/nixos
#
#echo
#echo "######################"
#echo "# customize hardware #"
#echo "######################"
#echo
#
#for i in ${DISKS}; do
#  sed -i \
#  "s|/dev/disk/by-id/|${i%/*}/|" \
#  "${MNT}"/etc/nixos/hosts/exampleHost/default.nix
#  break
#done
#
#diskNames=""
#for i in ${DISKS}; do
#  diskNames="${diskNames} \"${i##*/}\""
#done
#
#sed -i "s|\"bootDevices_placeholder\"|${diskNames}|g" \
#  "${MNT}"/etc/nixos/hosts/exampleHost/default.nix
#
#sed -i "s|\"abcd1234\"|\"$(head -c4 /dev/urandom | od -A none -t x4| sed 's| ||g' || true)\"|g" \
#  "${MNT}"/etc/nixos/hosts/exampleHost/default.nix
#
#sed -i "s|\"x86_64-linux\"|\"$(uname -m || true)-linux\"|g" \
#  "${MNT}"/etc/nixos/flake.nix
#
#cp "$(command -v nixos-generate-config || true)" ./nixos-generate-config
#
#chmod a+rw ./nixos-generate-config
#
## shellcheck disable=SC2016
#echo 'print STDOUT $initrdAvailableKernelModules' >> ./nixos-generate-config
#
#kernelModules="$(./nixos-generate-config --show-hardware-config --no-filesystems | tail -n1 || true)"
#
#sed -i "s|\"kernelModules_placeholder\"|${kernelModules}|g" \
#  "${MNT}"/etc/nixos/hosts/exampleHost/default.nix
#
#echo
#echo "#################################"
#echo "# set (temporary) root password #"
#echo "#################################"
#echo
#
#sed -i \
#"s|rootHash_placeholder|${rootPwd}|" \
#"${MNT}"/etc/nixos/configuration.nix
#
#echo
#echo "#########################"
#echo "# enable networkmanager #"
#echo "#########################"
#echo
#
#sed -i -e "/networkmanager/ s|false|true|" "${MNT}"/etc/nixos/configuration.nix
#
#echo
#echo "#####################"
#echo "# update flake.lock #"
#echo "#####################"
#echo
#
#nix flake update
#
#echo
#echo "##################"
#echo "# install system #"
#echo "##################"
#echo

#nixos-install \
#--root "${MNT}" \
#--no-root-passwd \
#--flake "git+file://${MNT}/etc/nixos#exampleHost"
#
#echo
#echo "#######################"
#echo "# unmount filesystems #"
#echo "#######################"
#echo
#
#umount -Rl "${MNT}"
#zpool export -a
#
#echo
#echo "##########"
#echo "# reboot #"
#echo "##########"
#echo
#
#reboot
