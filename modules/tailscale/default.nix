{ pkgs, user, home-manager, ... }:
{
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";  # enable tailscale exit nodes

  # Install tailscale GNOME extensions if GNOME is used
  home-manager.users.${user} = { lib, ... }: lib.mkIf config.services.xserver.desktopManager.gnome.enable {
    home.packages = with pkgs; [
      gnomeExtensions.taildrop-send
      gnomeExtensions.tailscale-status
    ];
    dconf.settings = {
      "org/gnome/shell/enabled-extensions" = [
        "tailscale-status@maxgallup.github.com"
      ];
    };
  };
}
