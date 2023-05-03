{ inputs, nixpkgs, home-manager, nixos-hardware, overlays, nur, ... }:
{
  work =
  let
    user = "ole";
    hostname = "work";
    system = "x86_64-linux";
    timezone = "Europe/Amsterdam";
    defaultlocale = "en_US.UTF-8";
  in
  nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs user overlays nur hostname timezone defaultlocale; };                 # Pass flake variable
    modules = [                                             # Modules that are used
      nixos-harware-nixosModules.dell-xps-13-9310
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
  };
}
