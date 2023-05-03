# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, system, user, overlays, ... }:

{
  # Use systemd boot (EFI only)
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.systemd-boot.configurationLimit = 5;
  #boot.loader.systemd-boot.consoleMode = "max";
  #boot.loader.systemd-boot.editor = false;
  #boot.loader.systemd-boot.memtest86.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  #boot.loader.timeout = 1;

  #fileSystems."/".neededForBoot = true;
  #fileSystems."/home".neededForBoot = true;
  #fileSystems."/persist".neededForBoot = true;

  #networking.hostName = "nixos-vm"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  #time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  #i18n.defaultLocale = "en_US.UTF-8";
  #console = {
  #  keyMap = "neo";
  #};

  #services = {
  #  # enable gnome-settings-daemon udev rules
  #  udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  #  # Enable the X11 windowing system.
  #  xserver.enable = true;

  #  # Enable the GNOME Desktop Environment.
  #  xserver.displayManager.gdm.enable = true;
  #  xserver.desktopManager.gnome.enable = true;

  #  # Configure keymap in X11
  #  xserver.layout = "de";
  #  xserver.xkbVariant = "neo";

  #  ## Enable VM Guest features
  #  #qemuGuest.enable = true;
  #  #spice-vdagentd.enable = true;

  #  # Enable CUPS to print documents.
  #  printing.enable = true;

  #  # Enable touchpad support (enabled default in most desktopManager).
  #  xserver.libinput.enable = true;

  #  # Pipewire
  #  pipewire.enable = true;

  #  # Enable Gnome browser plugins
  #  gnome.gnome-browser-connector.enable = true;
  #};

  ## Don't allow mutation of users outside of the config.
  #users.mutableUsers = false;

  ## Disable root account
  #users.users.root.hashedPassword = "!";

  ## Define a user account. Don't forget to set a password with ‘passwd’.
  #users.users.ole = {
  #  isNormalUser = true;
  #  passwordFile = "/persist/passwords/ole";
  #  extraGroups = [
  #    "wheel"  # Enable ‘sudo’ for the user.
  #    "docker"
  #  ];
  #  #shell = pkgs.fish;
  #};

  #virtualisation = {
  #  docker.enable = true;
  #};

  #nixpkgs = {
  #  config.allowUnfree = true;
  #  overlays = [
  #    overlays
  #  ];
  #};

  ## add fish to /etc/shells
  ## otherwise GDM does not show users with fish
  #environment.shells = with pkgs; [ fish ];

  ## enable completion for system packages like systemd
  #environment.pathsToLink = [ "/share/fish" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #environment.systemPackages = with pkgs; [
  #  # discord
  #];

  # Default applications
  #xdg.mime.defaultApplications = {
  #  "text/html" = "firefox.desktop";
  #  "x-scheme-handler/http" = "firefox.desktop";
  #  "x-scheme-handler/https" = "firefox.desktop";
  #  "x-scheme-handler/about" = "firefox.desktop";
  #  "x-scheme-handler/unknown" = "firefox.desktop";
  #};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  #programs.mtr.enable = true;
  #programs.gnupg.agent = {
  #  enable = true;
  #  enableSSHSupport = true;
  #};

  ## List services that you want to enable:

  ## Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  #system.stateVersion = "22.05"; # Did you read the comment?
}
