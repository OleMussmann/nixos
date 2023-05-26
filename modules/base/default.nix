{ pkgs, user, home-manager, hostname, timezone, defaultlocale, ... }:
{
  networking.hostName = "${hostname}";
  time.timeZone = "${timezone}";
  i18n.defaultLocale = "${defaultlocale}";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${user} = {
    home = {
      username = "${user}";
      homeDirectory = "/home/${user}";
      stateVersion = "22.05";

      sessionVariables = {
        # fuzzy finder
        FZF_DEFAULT_OPTS = "--color 16";  # use terminal color palette

        # nps
        NIX_PACKAGE_SEARCH_FLIP = "true";
        NIX_PACKAGE_SEARCH_EXPERIMENTAL = "true";
      };
    };
    programs = {
      direnv = {                         # custom environments per directory
        enable = true;
        nix-direnv.enable = true;
      };

      fzf = {
        enable = true;
        tmux.enableShellIntegration = true;
      };

      home-manager.enable = true;
      command-not-found.enable = false;  # broken for flakes-only builds without channels
      nix-index.enable = true;           # use nix-index instead of command-not-found
    };
  };

  # Default packages, install system-wide
  environment.systemPackages = with pkgs; [
    bat              # `cat` with syntax highlighting
    broot            # better `tree`
    btop             # system monitor
    #comma            # run programs without installing them
    cookiecutter     # coding templates
    exa              # better `ls`
    fd               # better `find`
    htop             # system monitor
    jq               # json parser
    killall          # kill process by name
    neofetch         # display system stats
    ncdu             # analyze disk usage
    neovim           # editor
    nvd              # nix version diff tool
    tealdeer         # command summaries
    tmux             # terminal multiplexer
    tree             # print directory structure
    unzip            # Zip files
    unrar            # Rar files
    wl-clipboard     # Wayland clipbord utilities
    wget             # network downloader

    # out-of-tree packages
    out-of-tree.nps  # nix package search
    out-of-tree.kaomoji  # kaomoji generator

    # unstable packages
    unstable.comma            # run programs without installing them
  ];

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    mtr.enable = true;
  };

  services = {
    openssh.enable = true;
    fwupd.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;

  # Don't allow mutation of users outside of the config.
  users.mutableUsers = false;

  # Disable root account
  users.users.root.hashedPassword = "!";

  users.users.${user} = {
    isNormalUser = true;
    passwordFile = "/persist/passwords/${user}";
    extraGroups = [ "wheel" ];  # Enable ‘sudo’ for the user.
  };
}
