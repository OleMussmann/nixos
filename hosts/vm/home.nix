{ pkgs, ... }:

{
  #imports =
  #  [
  #    #../../modules/desktop/bspwm/home.nix    # Window Manager
  #    ../../modules/desktop/hyprland/home.nix  # Window Manager
  #  ];

  home = {                                # Specific packages for desktop
    packages = with pkgs; [
      # Applications
      discord          # Comms
      ffmpeg           # Video Support
      firefox          # Browser
      gimp             # Graphical Editor
      handbrake        # Encoder
      inkscape         # Vector Graphical Editor
      libreoffice      # Office Packages
    ];
  };
