{ pkgs, lib, user, ... }:

let kgx_patched = pkgs.kgx.overrideAttrs( oldAttrs: { patches = [ ../../patches/kgx/atelierlakeside.alpha_0.97.hybrid.alpha_0.97.patch ]; } );
in {
  fonts.fontconfig.enable = true;

  home = {                                # Specific packages for desktop

    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "22.05";

    packages = with pkgs; [
      # Applications
      any-nix-shell    # use fish in nix-shell
      appimage-run     # Runs AppImages on NixOS
      chromium         # Browser
      dconf2nix        # turn GNOME dconf settings to nix strings
      discord          # Comms
      ffmpeg           # Video support
      firefox          # Browser
      gimp             # Graphical editor
      handbrake        # Encoder
      inkscape         # Vector graphical editor
      keepassxc        # Password manager
      libreoffice      # Office packages
      nextcloud-client # File sync
      #slack-dark       # Comms
      transmission     # Torrent client
      xorg.xkill       # Kill applications

      # GNOME extensions
      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-dock
      gnomeExtensions.gsconnect
      gnomeExtensions.pop-shell

      # Extra GNOME packages
      gnome3.gnome-tweaks

      # Patched packages
      kgx_patched

      # fish plugins
      fishPlugins.autopair-fish      # helper for brackets and quotation marks
      fishPlugins.colored-man-pages  # yay, colors!
      fishPlugins.sponge             # remove failed commands from history

      # Overrides
      (nerdfonts.override {
        fonts = [
          "Ubuntu"
          "UbuntuMono"
          "DroidSansMono"
          "RobotoMono"
        ];
      })
    ];

    sessionVariables = {
      # fuzzy finder
      FZF_DEFAULT_OPTS = "--color 16";  # use terminal color palette

      # nps
      NIX_PACKAGE_SEARCH_FLIP = "true";
      NIX_PACKAGE_SEARCH_EXPERIMENTAL = "true";
      NIX_PACKAGE_SEARCH_SHOW_PACKAGE_DESCRIPTION = "false";
    };
  };

  # Configure GNOME
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Console.desktop"
	"slack.desktop"
      ];
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };

    "org/gnome/Console" = {
      
      scrollback-lines = "int64 -1";  # Infinite scrollback
      theme = "auto";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "LEFT";
      extend-height = true;
      show-apps-at-top = true;
      custom-theme-shrink = true;
      apply-custom-theme = true;
      disable-overview-on-startup = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
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

    # Silence!
    "org/gnome/desktop/sounds" = {
      event-sounds = "false";
    };

    # Console keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>t";
      command = "kgx";
      name = "Launch Console";
    };
  };

  programs = {
    home-manager.enable = true;
    command-not-found.enable = false;  # broken for flakes-only builds without channels
    nix-index.enable = true;           # use nix-index instead of command-not-found

    fish = {
      enable = true;
      shellAbbrs = {
        ll = "ls -l";
        trash = "gio trash";
        update = "nix flake update --commit-lock-file /home/ole/.system";
        upgrade = "sudo nixos-rebuild switch --flake /home/ole/.system#work";
      };
      promptInit = ''
        any-shell-nix fish | source
      '';
      interactiveShellInit = ''
        set fish_greeting ""
      '';
    };

    fzf ={
      enable = true;
      tmux.enableShellIntegration = true;
    };

    starship = {
      enable = true;
      settings = {
        format = lib.concatStrings [
          "$directory"
          "$all"
        ];
        right_format = lib.concatStrings [
          "$git_branch"
          "$git_status"
          "$cmd_duration"
        ];
        add_newline = false;
        #linebreak.disabled = true;
        character = {
          success_symbol = " [](#6791c9)";
          error_symbol = " [](#df5b61)";
          vicmd_symbol = "[  ](#78b892)";
        };
        hostname = {
          ssh_only = true;
          format = "[$hostname](bold blue) ";
          disabled = false;
        };
        cmd_duration = {
          #min_time = 1;
          format = "[](fg:#1c252c bg:none)[$duration]($style)[](fg:#1c252c bg:#1c252c)[](fg:#bc83e3 bg:#1c252c)[ ](fg:#1c252c bg:#bc83e3)[](fg:#bc83e3 bg:none) ";
          disabled = false;
          style = "fg:#d9d7d6 bg:#1c252c";
        };
        directory = {
          format = "[](fg:#1c252c bg:none)[$path]($style)[](fg:#1c252c bg:#1c252c)[](fg:#6791c9 bg:#1c252c)[ ](fg:#1c252c bg:#6791c9)[](fg:#6791c9 bg:none)";
          style = "fg:#d9d7d6 bg:#1c252c";
          truncation_length = 3;
          truncate_to_repo = false;
        };
        git_branch = {
          format = "[](fg:#1c252c bg:none)[$branch]($style)[](fg:#1c252c bg:#1c252c)[](fg:#78b892 bg:#1c252c)[](fg:#282c34 bg:#78b892)[](fg:#78b892 bg:none) ";
          style = "fg:#d9d7d6 bg:#1c252c";
        };
        git_status = {
          format="[](fg:#1c252c bg:none)[$all_status$ahead_behind]($style)[](fg:#1c252c bg:#1c252c)[](fg:#67afc1 bg:#1c252c)[ ](fg:#1c252c bg:#67afc1)[](fg:#67afc1 bg:none) ";
          style = "fg:#d9d7d6 bg:#1c252c";
          conflicted = "=";
          ahead = "⇡\${count}";
          behind = "⇣\${count}";
          diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
          up_to_date = "";
          untracked = "?\${count}";
          stashed = "";
          modified = "!\${count}";
          staged = "+\${count}";
          renamed = "»\${count}";
          deleted = "\${count}";
        };
        git_commit = {
          format = "[\\($hash\\)]($style) [\\($tag\\)]($style)";
          style = "green";
        };
        git_state = {
          rebase = "REBASING";
          merge = "MERGING";
          revert = "REVERTING";
          cherry_pick = "CHERRY-PICKING";
          bisect = "BISECTING";
          am = "AM";
          am_or_rebase = "AM/REBASE";
          style = "yellow";
          format = "([\$state( \$progress_current/\$progress_total)](\$style)) ";
        };
      };
    };

    git = {
      enable = true;
      userName  = "Ole Mussmann";
      userEmail = "gitlab+account@ole.mn";
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
  };
}
