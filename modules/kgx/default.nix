{ pkgs, user, ... }:
let kgx_patched = pkgs.kgx.overrideAttrs(
  oldAttrs: {
    patches = [ ../../patches/kgx/atelierlakeside.alpha_0.97.hybrid.alpha_0.97.patch ];
  }
);
in
{
  home-manager.users.${user} = {
    home = {
      packages = with pkgs; [
        kgx_patched
      ];
    };
    dconf.settings = {
      "org/gnome/Console" = {
        scrollback-lines = "int64 -1";  # Infinite scrollback
        theme = "auto";
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
  };
}
