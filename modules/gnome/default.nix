{ pkgs, user, ... }:
{
  services = {
    # enable gnome-settings-daemon udev rules
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
    # Enable the X11 windowing system.
    xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    xserver.displayManager.gdm.enable = true;
    xserver.desktopManager.gnome.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    xserver.libinput.enable = true;

    # Pipewire
    pipewire.enable = true;

    # Enable Gnome browser plugins
    gnome.gnome-browser-connector.enable = true;
  };
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  fonts.fontconfig.enable = true;

  home-manager.users.${user} = {
    home = {
      packages = with pkgs; [
        # Applications
        dconf2nix        # turn GNOME dconf settings to nix strings

        # GNOME extensions
        gnomeExtensions.appindicator
        gnomeExtensions.caffeine
        gnomeExtensions.dash-to-dock
        gnomeExtensions.gsconnect
        gnomeExtensions.pop-shell

        # Extra GNOME packages
        gnome3.gnome-tweaks

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
    };

    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "dash-to-dock@micxgx.gmail.com"
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
          "appindicatorsupport@rgcjonas.gmail.com"
          "caffeine@patapon.info"
        ];
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

      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
      };

      # Fractional scaling
      "org/gnome/mutter" = {
        experimental-features = [ "scale-monitor-framebuffer" ];
      };
    };
  };
}
