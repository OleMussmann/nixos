{ config, lib, pkgs, inputs, user, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  # Default packages, install system-wide
  environment.systemPackages = with pkgs; [
    bat              # `cat` with syntax highlighting
    broot            # better `tree`
    btop             # system monitor
    exa              # better `ls`
    fd               # better `find`
    htop             # system monitor
    killall          # kill process by name
    neofetch         # display system stats
    ncdu             # analyze disk usage
    neovim           # editor
    tealdeer         # command summaries
    tmux             # terminal multiplexer
    tree             # print directory structure
    unzip            # Zip files
    unrar            # Rar files
    wl-clipboard     # Wayland clipbord utilities
    wget             # network downloader

    # out-of-tree packages
    out-of-tree.nps  # nix package search
  ];

  # machine-id is used by systemd for the journal, if you don't
  # persist this file you won't be able to easily use journalctl to
  # look at journals for previous boots.
  #
  # If you want to run an openssh daemon, you may want to store the
  # host keys across reboots. For this to work you will need to
  # create the directory yourself:
  # $ mkdir /persist/etc/ssh
  environment = {
    etc = {
      "machine-id".source = "/persist/etc/machine-id";
      "ssh/ssh_host_rsa_key".source = "/persist/etc/ssh/ssh_host_rsa_key";
      "ssh/ssh_host_rsa_key.pub".source = "/persist/etc/ssh/ssh_host_rsa_key.pub";
      "ssh/ssh_host_ed25519_key".source = "/persist/etc/ssh/ssh_host_ed25519_key";
      "ssh/ssh_host_ed25519_key.pub".source = "/persist/etc/ssh/ssh_host_ed25519_key.pub";
    };
    persistence."/persist" = {
      directories = [
        "/var/lib/bluetooth"
        "/etc/NetworkManager/system-connections"
        "/etc/wireguard"
      ];
    };
  };

  # persist bluetooth connections
  systemd.tmpfiles.rules = [
    # persist if user was lectured about `sudo` responsibilities
    "L /var/db/sudo/lectured - - - - /persist/var/db/sudo/lectured"
  ];

  # workaround for networkmanager bug, see https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  # Nix Package Manager settings
  nix = {
    settings ={
      auto-optimise-store = true;           # Optimise syslinks
      keep-outputs        = true;           # Keep packages needed for building other packages
      fallback            = true;           # Build from source if binary substitute fails
      log-lines           = 25;             # Keep more log lines if things go wrong
    };
    gc = {                                  # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
