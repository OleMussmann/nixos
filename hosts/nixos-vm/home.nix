{ config, pkgs, lib, user, nur, ... }:

let kgx_patched = pkgs.kgx.overrideAttrs( oldAttrs: { patches = [ ../../patches/kgx/atelierlakeside.alpha_0.97.hybrid.alpha_0.97.patch ]; } );
#let kgx_patched = pkgs.kgx.overrideAttrs( oldAttrs: {
#  patches = [ 
#    (pkgs.fetchpatch {
#      url = "https://raw.githubusercontent.com/OleMussmann/kgx-themes/v0.0.1/patches/dark/dracula.alpha_0.95.patch";
#      sha256 = "sha256-853zE8RJMlSVIQQmGKjp3Hvg5/aQtFHk6g5jz76knbA=";
#    })
#  ];
#});
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
      comma            # run programs without installing them
      chromium         # Browser
      dconf2nix        # turn GNOME dconf settings to nix strings
      ffmpeg           # Video support
      #firefox          # Browser
      gimp             # Graphical editor
      inkscape         # Vector graphical editor
      jq               # json parser
      keepassxc        # Password manager
      nextcloud-client # File sync
      nvd              # nix version diff tool
      pika-backup      # borg frontend
      transmission     # Torrent client
      xorg.xkill       # Kill applications
      zoom-us          # comms

      # Applications from unstable channel
      unstable.logseq           # knowledge base

      # Applications from third party repos
      third-party.entangled
      third-party.fzf-search
      third-party.wipeclean

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

      # default editor
      EDITOR = "nvim";
    };
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
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
    };

    # Silence!
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

    # Console keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>t";
      command = "kgx";
      name = "Launch Console";
    };

    # Fractional scaling
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
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
        duckduckgo-privacy-essentials
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
      functions = {
        take = "mkdir -p \"$argv\"; and cd \"$argv[-1]\"";
      };
      shellAbbrs = {
        ll = "ls -l";
      };
      shellAliases = {
        trash = "gio trash";
        update = "nix flake update --commit-lock-file /home/ole/.system";
        upgrade = "sudo nixos-rebuild switch --flake /home/ole/.system#nixos-vm &&
          nvd diff $(ls -d1v /nix/var/nix/profiles/system-*-link | tail -n 2)";
      };
      interactiveShellInit = ''
        set fish_greeting ""
        fish_vi_key_bindings
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
	custom = {
	  direnv = {
	    command = "nix flake metadata --json 2>/dev/null | jq '.description' | sed -e 's/\"//g'; if [ \"\$\{PIPESTATUS[0]\}\" != \"0\" ]; then basename \"$PWD\"; fi ";
	    shell = "bash";
	    format = "[$symbol$output]($style)";
	    style = "fg:bold green";
	    symbol = "📁 ";
	    when = "env | grep -E '^DIRENV_FILE='";
	  };
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
      extraConfig = ''
        colorscheme tokyonight-night
        set colorcolumn=80
        set ignorecase
        set scrolloff=3
        set smartcase

        " print invisible characters
        "set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
        set listchars=tab:→\ ,nbsp:␣,trail:•,precedes:«,extends:»
        set list

        " numbering
        set number
        set relativenumber

        " tabs and spaces handling
        set expandtab
        set tabstop=2
        set softtabstop=2
        set shiftwidth=2
      '';
      extraPackages = with pkgs; [
        gcc
        ripgrep
        tree-sitter
      ];
      plugins = with pkgs.vimPlugins; [
        #cmp-treesitter                   # use treesitter for nvim-cmp
        #diffview-nvim                    # single tabpage interface for diffs
        #gitsigns-nvim                    # git decorations
        ##hop-nvim                         # jump anywhere
        indent-blankline-nvim            # indentation guides
        #lualine-nvim                     # status line
        nerdcommenter                    # better commenting
        #null-ls-nvim                     # make non-lsp plugins hook into lsp
        #nvim-dap                         # debug adapter protocol, dependency for telescope-dap-nvim
        #nvim-surround                    # surround selections
        #nvim-treesitter.withAllGrammars  # syntax highlighting
        #nvim-treesitter-context          # show code context
        #nvim-treesitter-pyfold           # smart folding
        #nvim-treesitter-refactor         # refactoring
        #nvim-treesitter-textobjects      # syntax aware text-objects
        #nvim-cmp                         # completion
        #plenary-nvim                     # lua functions, dependency for telescope
        #telescope-dap-nvim               # debug adapter protocol integrated in telescope
        #telescope-lsp-handlers-nvim      # ??
        #telescope-live-grep-args-nvim    # ??
        #telescope-frecency-nvim          # file priorization by frequency and recency
        #telescope-file-browser-nvim      # file browser
        #telescope-fzf-native-nvim        # fzf for telescope
        #telescope-nvim                   # fuzzy finder
        #telescope-symbols-nvim           # pick and insert symbols
        #telescope-ultisnips-nvim         # smart snippets
        #toggleterm-nvim                  # quick terminal
        tokyonight-nvim                  # theme
        #ultisnips                        # smart snippets, dependency for telescope-ultisnips-nvim
        vim-nix                          # syntax highlighting for nix
        #vim-fugitive                     # git integration
        #vim-repeat                       # repeat also plugin commands
      ];
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withPython3 = true;
    };
  };
}
