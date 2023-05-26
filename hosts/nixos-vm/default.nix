{ self, inputs, nixpkgs, home-manager, overlays, nur, ... }:
let
  user = "ole";
  hostname = "nixos-vm";
  timezone = "Europe/Amsterdam";
  defaultlocale = "en_US.UTF-8";
in
{
  specialArgs = { inherit self inputs user overlays nur hostname timezone defaultlocale; };                 # Pass flake variable
  modules = [                                             # Modules that are used
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/desktop
    ../../modules/impermanence

    ../../modules/comms
    ../../modules/docker
    ../../modules/firefox
    ../../modules/fish
    ../../modules/git
    ../../modules/gnome
    ../../modules/kgx
    ../../modules/neo_layout
    ../../modules/neovim
    ../../modules/nix
    ../../modules/starship
    ../../modules/vm_guest

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
