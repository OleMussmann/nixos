{ config, pkgs, lib, user, nur, ... }:

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
      element-desktop  # Comms
      ffmpeg           # Video support
      #firefox          # Browser
      gimp             # Graphical editor
      handbrake        # Encoder
      inkscape         # Vector graphical editor
      keepassxc        # Password manager
      libreoffice      # Office packages
      logseq           # knowledge base
      nextcloud-client # File sync
      nvd              # nix version diff tool
      slack-dark       # Comms
      todoist-electron # todo app
      transmission     # Torrent client
      xorg.xkill       # Kill applications
      zoom-us          # comms

      # GNOME extensions
      gnomeExtensions.appindicator
      gnomeExtensions.caffeine
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

    #file = {
    #  # enable command-not-found for fish
    #  "bin/nix-command-not-found" = {
    #    text = ''
    #      #!/usr/bin/env bash
    #      source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    #      command_not_found_handle "$@"
    #    '';

    #    executable = true;
    #  };
    #};
  };

  # Configure GNOME
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "chromium-browser.desktop"
        "org.gnome.Console.desktop"
        "org.keepassxc.KeePassXC.desktop"
        "org.gnome.Nautilus.desktop"
        "logseq.desktop"
        "slack.desktop"
	"element-desktop.desktop"
      ];
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "caffeine@patapon.info"
      ];
    };

    "org/gnome/Console" = {
      
      scrollback-lines = "int64 -1";  # Infinite scrollback
      theme = "auto";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = true;
      custom-theme-shrink = true;
      disable-overview-on-startup = true;
      dock-position = "LEFT";
      extend-height = true;
      show-apps-at-top = true;
      show-show-apps-button = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      speed = 0.45;
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
      show-battery-percentage = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Ubuntu Nerd Font Bold 11";
      action-right-click-titlebar = "menu";
      action-middle-click-titlebar = "minimize";
      button-layout = "appmenu:minimize,maximize,close";
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

    direnv = {                         # custom environments per directory
      enable = true;
      nix-direnv.enable = true;
    };

    firefox = {
      enable = true;
      #enableGnomeExtensions = true;
      profiles.default = {
        id = 0;
        name = "Default";
        isDefault = true;
        search.force = true;  # Keep firefox from overwriting search.json.mozlz4
        search.default = "DuckDuckGo";
	search.engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
          };
	};
        settings = {
	  "browser.startup.page" = 3;  # Restore previous session
	  "browser.toolbars.bookmarks.visibility" = "never";
          "browser.newtabpage.activity-stream.topSitesRows" = 2;
          "signon.rememberSignons" = false;
          "browser.newtabpage.pinned" = "[{\"url\":\"https://www.heise.de/\",\"label\":\"heise\"},{\"url\":\"https://www.golem.de/\",\"label\":\"golem\"},{\"url\":\"https://tweakers.net/\",\"label\":\"tweakers\"},{\"url\":\"https://arstechnica.com/\"},{\"url\":\"https://www.phoronix.com/\",\"label\":\"phoronix\"},{\"url\":\"https://www.theverge.com/\"},{\"url\":\"https://www.engadget.com\",\"label\":\"engadget\"},{\"url\":\"https://www.trustedreviews.com/\",\"label\":\"trustedreviews\"},{\"url\":\"https://www.theregister.com/\",\"label\":\"theregister\"},{\"url\":\"https://search.nixos.org/\",\"label\":\"search.nixos\"},{\"url\":\"https://nix-community.github.io/home-manager/options.html\",\"label\":\"nix-community\"}]";
        };
      };
      extensions = with config.nur.repos.rycee.firefox-addons; [
        consent-o-matic
	darkreader
        floccus
        gsconnect
        keepassxc-browser
        tridactyl
        ublock-origin
        vimium
      ];
      package = pkgs.firefox.override {
        # See nixpkgs' firefox/wrapper.nix to check which options you can use
        cfg = {
          # Gnome shell native connector
          enableGnomeExtensions = true;
        };
      };
    };

    fish = {
      enable = true;
      #functions = {
      #  __fish_command_not_found_handler = {
      #    body = "~/bin/command-not-found $argv[1]";
      #    onEvent = "fish_command_not_found";
      #  };
      #};
      shellAbbrs = {
        ll = "ls -l";
      };
      shellAliases = {
        trash = "gio trash";
        update = "nix flake update --commit-lock-file /home/ole/.system";
        upgrade = "sudo nixos-rebuild switch --flake /home/ole/.system#work &&
	  nvd diff $(ls -d1v /nix/var/nix/profiles/system-*-link | tail -n 2)";
      };
      interactiveShellInit = ''
        set fish_greeting ""
        any-nix-shell fish | source
      '';
    };

    fzf = {
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
