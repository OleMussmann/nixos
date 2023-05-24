{ config, pkgs, user, ... }:
{
  home-manager.users.${user} = {
    home = {
      packages = with pkgs; [
        discord
        element-desktop
        signal-desktop
        slack-dark
        zoom-us
      ]
      ++ (
        # Install libunity if GNOME is enabled
        if config.services.xserver.desktopManager.gnome.enable then [
          libunity         # Unity integration, to show Discord icon
        ]
        else []
      );
    };
  };
}
