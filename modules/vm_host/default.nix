{ config, user, lib, ... }:
{
  virtualizaton.libvirtd.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    virt-manager
  ]
  ++ (
    # Install GNOME Boxes if GNOME is used
    if config.services.xserver.desktopManager.gnome.enable then [
      gnome.gnome-boxes
    ]
    else []
  );
}


