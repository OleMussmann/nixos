{ pkgs, lib, ... }:

let kgx_patched = pkgs.kgx.overrideAttrs( oldAttrs: rec { patches = [ ../../patches/kgx/0001-apply-dual-snazzy-color-scheme.patch ]; } );
in {
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
      dconf2nix        # turn GNOME dconf settings to nix strings

      # GNOME extensions
      gnomeExtensions.dash-to-dock
      gnomeExtensions.gsconnect
      kgx_patched
    ];
  };

  dconf.settings = {

    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
      ];
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
	"drive-menu@gnome-shell-extensions.gcampax.github.com"
      ];
    };

    "org/gnome/Console" = {
      scrollback-lines = "int64 -1";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "LEFT";
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    "org/gnome/desktop/interface" = {
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      document-font-name = "Ubuntu Nerd Font 11";
      font-name = "Ubuntu Nerd Font 11";
      monospace-font-name = "UbuntuMono Nerd Font Mono 13";
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Ubuntu Nerd Font Bold 11";
      action-right-click-titlebar = "menu";
      action-middle-click-titlebar = "minimize";
    };

    "org/gnome/desktop/sounds" = {
      event-sounds = "false";
    };

    # Prevent screen timeout for VM
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 0;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>t";
      command = "kgx";
      name = "Launch Console";
    };
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      extended = true;     # save timestamps
      save = 100000;
      size = 100000;
    };
    historySubstringSearch = {
      enable = true;
    };
    shellAliases = {
      ll = "ls -l";
      trash = "gio trash";
      update = "cd /home/ole/.system && nix flake update --commit-lock-file";
      upgrade = "sudo nixos-rebuild switch --flake /home/ole/.system#nixos-vm";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "colored-man-pages" "history" ];
      theme = "robbyrussell";
    };
  };

  programs.fzf ={
    enable = true;
    colors = {
      "fg" = "#dedede";
      "bg" = "#121212";
      "hl" = "#666666";
      "fg+" = "#eeeeee";
      "bg+" = "#282828";
      "hl+" = "#cf73e6";
      "info" = "#cf73e6";
      "prompt" = "#ff0000";
      "spinner" = "#cf73e6";
      "pointer" = "#cf73e6";
      "marker" = "#f0d50c";
    };
    tmux.enableShellIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      #format = lib.concatStrings [
      #  "$line_break"
      #  "$package"
      #  "$line_break"
      #  "$character"
      #];
      #scan_timeout = 10;
      #character = {
      #  success_symbol = "➜";
      #  error_symbol = "➜";
      #};
    };
  };

  programs.git = {
    enable = true;
    userName  = "ole";
    userEmail = "gitlab+account@ole.mn";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
