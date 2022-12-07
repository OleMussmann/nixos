{ config, lib, pkgs, inputs, user, location, ... }:

{
  environment.systemPackages = with pkgs; [           # Default packages install system-wide
    bat
    htop
    inputs.nps.defaultPackage.x86_64-linux
    killall
    ncdu
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    tmux
    tree
    wget
  ];

  # machine-id is used by systemd for the journal, if you don't
  # persist this file you won't be able to easily use journalctl to
  # look at journals for previous boots.
  #
  # If you want to run an openssh daemon, you may want to store the
  # host keys across reboots. For this to work you will need to
  # create the directory yourself:
  # $ mkdir /persist/etc/ssh
  environment.etc = {
    "machine-id".source = "/persist/etc/machine-id";
    "ssh/ssh_host_rsa_key".source = "/persist/etc/ssh/ssh_host_rsa_key";
    "ssh/ssh_host_rsa_key.pub".source = "/persist/etc/ssh/ssh_host_rsa_key.pub";
    "ssh/ssh_host_ed25519_key".source = "/persist/etc/ssh/ssh_host_ed25519_key";
    "ssh/ssh_host_ed25519_key.pub".source = "/persist/etc/ssh/ssh_host_ed25519_key.pub";
  };
  systemd.tmpfiles.rules = [
    "L /var/db/sudo/lectured - - - - /persist/var/db/sudo/lectured"
  ];

  nix = {                                   # Nix Package Manager settings
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
  nixpkgs.config.allowUnfree = true;        # Allow proprietary software
  system.stateVersion = "22.05";
}
