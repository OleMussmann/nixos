{ self, inputs, nixpkgs, home-manager, nixos-hardware, overlays, nur, ... }:
let
  user = "ole";
  hostname = "work";
  timezone = "Europe/Amsterdam";
  defaultlocale = "en_US.UTF-8";
in
{
  specialArgs = { inherit self inputs user overlays nur hostname timezone defaultlocale; };                 # Pass flake variable
  modules = [                                             # Modules that are used
    nixos-hardware.nixosModules.dell-xps-13-9310
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/desktop
    ../../modules/impermanence

    ../../modules/comms
    ../../modules/docker
    ../../modules/fingerprint_reader_goodix
    ../../modules/firefox
    ../../modules/fish
    ../../modules/git
    ../../modules/gnome
    ../../modules/kgx
    ../../modules/neo_layout
    ../../modules/neovim
    ../../modules/nix
    ../../modules/starship
    ../../modules/tailscale
    ../../modules/vm_host

    ({ config, pkgs, lib, ... }:
    {
      nixpkgs.overlays = [
        (
          self: super:
          {
            wpa_supplicant = super.wpa_supplicant.overrideAttrs ( old: rec {
              buildInputs = super.lib.lists.remove super.openssl old.buildInputs ++ [ self.openssl_1_1 ];
            });
          }
        )
      ];
    })

    home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
      home-manager.users.${user} = {
        dconf.settings = {
          "org/gnome/shell" = {
            favorite-apps = [
              "firefox.desktop"
              "chromium-browser.desktop"
              "org.gnome.Console.desktop"
              "org.keepassxc.KeePassXC.desktop"
              "org.gnome.Nautilus.desktop"
              "logseq.desktop"
              "slack.desktop"
              "element-desktop.desktop"
            ];
          };
        };
      };
    }
  ];
}
