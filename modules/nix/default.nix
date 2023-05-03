{ lib, inputs, overlays, ... }:

{
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

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      overlays
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
