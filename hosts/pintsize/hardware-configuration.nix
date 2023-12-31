# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  ##### 💽 START root filesystem choice #####
  ##### ⬇️  use this block for tmpfs     #####
  #fileSystems."/" =
  #  { device = "none";
  #    fsType = "tmpfs";
  #    options = [ "defaults" "size=2G" "mode=755" ];
  #  };
  ##### ⬆️  use this block for tmpfs     #####

  ##### ⬇️  or use this block for zfs    #####
  fileSystems."/" =
    { device = "rpool/nixos";
      fsType = "zfs";
    };
  # use blank snapshot for every boot
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/nixos@blank
  '';
  ##### ⬆️  or use this block for zfs    #####
  ##### 💽 END root filesystem choice   #####

  fileSystems."/nix" =
    { device = "rpool/nixos/nix";
      fsType = "zfs";
    };

  fileSystems."/backups" =
    { device = "rpool/nixos/backups";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "rpool/nixos/home";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    { device = "rpool/nixos/persist";
      fsType = "zfs";
    };

  fileSystems."/var/lib" =
    { device = "rpool/nixos/var/lib";
      fsType = "zfs";
    };

  fileSystems."/var/log" =
    { device = "rpool/nixos/var/log";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/EE0E-F143";
      fsType = "vfat";
    };

  swapDevices =
    [
      {
        device = "/dev/disk/by-partuuid/a1775cea-c621-4da2-a11e-9a0807280c4d";
        randomEncryption.enable = true;
      }
      {
        device = "/dev/disk/by-partuuid/d3067b4b-8115-48c3-bd4d-c8ea2e4a596a";
        randomEncryption.enable = true;
      }
    ];

  # ZFS settings
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "362a7070";
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.zfs.devNodes = "/dev/disk/by-path";
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
