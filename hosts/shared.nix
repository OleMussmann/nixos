{ config, lib, pkgs, inputs, user, location, ... }:

{
  environment.systemPackages = with pkgs; [           # Default packages install system-wide
      git
      inputs.nps.defaultPackage.x86_64-linux
      killall
      ncdu
      neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      tree
      wget
    ];

  nix = {                                   # Nix Package Manager settings
    settings ={
      auto-optimise-store = true;           # Optimise syslinks
    };
    gc = {                                  # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    #package = pkgs.nixVersions.unstable;    # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;        # Allow proprietary software.
  system.stateVersion = "22.05";
}
