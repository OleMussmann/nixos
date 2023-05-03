{ config, lib, pkgs, user, nur, ... }:
{
  imports = [ nur.nixosModules.nur ];
  home-manager.users.${user} =
  {
    programs.firefox = {
      enable = true;
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
        # Enable GNOME shell native connector if GNOME is used
        cfg = lib.mkIf config.services.xserver.desktopManager.gnome.enable {
          enableGnomeExtensions = true;
        };
      };
    };
  };
  xdg.mime.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };
}
