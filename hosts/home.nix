{ config, lib, pkgs, user, ... }:

{ 
  #imports =                                   # Home Manager Modules
  #  (import ../modules/editors) ++
  #  (import ../modules/programs) ++
  #  (import ../modules/services);

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # Terminal
      btop              # Resource Manager
      pfetch            # Minimal fetch
      ranger            # File Manager
      tldr              # Helper

      # Video/Audio
      feh               # Image Viewer
      mpv               # Media Player
      pavucontrol       # Audio control
      plex-media-player # Media Player
      vlc               # Media Player
      stremio           # Media Streamer

      # Apps
      appimage-run      # Runs AppImages on NixOS
      firefox           # Browser
      google-chrome     # Browser
      remmina           # XRDP & VNC Client

      # File Management
      okular            # PDF viewer
      gnome.file-roller # Archive Manager
      pcmanfm           # File Manager
      rsync             # Syncer $ rsync -r dir1/ dir2/
      unzip             # Zip files
      unrar             # Rar files

      # General configuration
      #git              # Repositories
      #killall          # Stop Applications
      #nano             # Text Editor
      #pciutils         # Computer utility info
      #pipewire         # Sound
      #usbutils         # USB utility info
      #wacomtablet      # Wacom Tablet
      #wget             # Downloader
      #zsh              # Shell
      #
      # General home-manager
      #alacritty        # Terminal Emulator
      #dunst            # Notifications
      #doom emacs       # Text Editor
      #libnotify        # Dep for Dunst
      #neovim           # Text Editor
      #rofi             # Menu
      #rofi-power-menu  # Power Menu
      #udiskie          # Auto Mounting
      #vim              # Text Editor
      #
      # Xorg configuration
      #xclip            # Console Clipboard
      #xorg.xev         # Input viewer
      #xorg.xkill       # Kill Applications
      #xorg.xrandr      # Screen settings
      #xterm            # Terminal
      #
      # Xorg home-manager
      #flameshot        # Screenshot
      #picom            # Compositer
      #sxhkd            # Shortcuts
      #
      # Wayland configuration
      #autotiling       # Tiling Script
      #grim             # Image Grabber
      #mpvpaper         # Video Wallpaper
      #slurp            # Region Selector
      #swappy           # Screenshot Editor
      #swayidle         # Idle Management Daemon
      #wev              # Input viewer
      #wl-clipboard     # Console Clipboard
      #
      # Wayland home-manager
      #pamixer          # Pulse Audio Mixer
      #swaylock-fancy   # Screen Locker
      #waybar           # Bar
      #
      # Desktop
      #blueman          # Bluetooth
      #deluge           # Torrents
      #discord          # Chat
      #ffmpeg           # Video Support (dslr)
      #gmtp             # Mount MTP (GoPro)
      #gphoto2          # Digital Photography
      #handbrake        # Encoder
      #heroic           # Game Launcher
      #hugo             # Static Website Builder
      #lutris           # Game Launcher
      #mkvtoolnix       # Matroska Tool
      #plex-media-player# Media Player
      #prismlauncher    # MC Launcher
      #steam            # Games
      #simple-scan      # Scanning
      # 
      # Laptop
      #blueman          # Bluetooth
      #light            # Display Brightness
      #libreoffice      # Office Tools
      #simple-scan      # Scanning
      #
      # Flatpak
      #obs-studio       # Recording/Live Streaming
    ];
    file.".config/wall".source = ../modules/themes/wall;
    file.".config/wall.mp4".source = ../modules/themes/wall.mp4;
    pointerCursor = {                         # This will set cursor systemwide so applications can not choose their own
      #name = "Dracula-cursors";
      name = "Catppuccin-Mocha-Dark-Cursors";
      #package = pkgs.dracula-theme;
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 16;
    };
    stateVersion = "22.05";
  };

  programs = {
    home-manager.enable = true;
  };

  gtk = {                                     # Theming
    enable = true;
    theme = {
      name = "Dracula";
      #name = "Catppuccin-Dark";
      package = pkgs.dracula-theme;
      #package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrains Mono Medium";         # or FiraCode Nerd Font Mono Medium
    };                                        # Cursor is declared under home.pointerCursor
  };
}
