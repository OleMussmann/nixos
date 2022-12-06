{ config, lib, pkgs, inputs, user, location, ... }:

{
  environment.systemPackages = with pkgs; [           # Default packages install system-wide
      htop
      inputs.nps.defaultPackage.x86_64-linux
      killall
      ncdu
      neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      tmux
      tree
      wget
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
