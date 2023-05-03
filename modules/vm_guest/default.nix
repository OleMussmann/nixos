{ config, user, lib, ... }:
{
  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };

  # Prevent screen timeout for VM, if GNOME is enabled
  home-manager.users.${user} = { lib, ... }: lib.mkIf config.services.xserver.desktopManager.gnome.enable {
    dconf.settings = {
      
      "org/gnome/desktop/session" = {
        idle-delay = lib.hm.gvariant.mkUint32 0;
      };
    };
  };
}
