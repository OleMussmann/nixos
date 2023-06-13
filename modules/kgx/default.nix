{ pkgs, user, ... }:
{
  home-manager.users.${user} = {
    home = {
      packages = with pkgs; [
        kgx-themed
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
