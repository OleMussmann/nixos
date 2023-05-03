{ inputs, nixpkgs, home-manager, nixos-hardware, overlays, nur, ... }:
{
  nixos-vm =
  let
    user = "ole";
    hostname = "nixos-vm";
    system = "x86_64-linux";
    timezone = "Europe/Amsterdam";
    defaultlocale = "en_US.UTF-8";
  in
  nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs user overlays nur hostname timezone defaultlocale; };                 # Pass flake variable
    modules = [                                             # Modules that are used
      #./nixos-vm
      ./nixos-vm/hardware-configuration.nix
      ../modules/base
      ../modules/desktop
      ../modules/impermanence

      ../modules/comms
      ../modules/docker
      ../modules/firefox
      ../modules/fish
      ../modules/git
      ../modules/gnome
      ../modules/kgx
      ../modules/neovim
      ../modules/neo_layout
      ../modules/nix
      ../modules/starship
      ../modules/vm_guest

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

  #work = nixpkgs.lib.nixosSystem {                          # work profile
  #  system = "x86_64-linux";                                # System architecture
  #  specialArgs = { inherit inputs user; };                 # Pass flake variable
  #  modules = [                                             # Modules that are used
  #    ({ config, pkgs, ... }: {
  #      nixpkgs.overlays = [
  #        overlays
  #      ];
  #    })
  #    nixos-hardware.nixosModules.dell-xps-13-9310          # Hardware support
  #    nur.nixosModules.nur
  #    ./work
  #    ./shared.nix

  #    home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
  #      home-manager.useGlobalPkgs = true;
  #      home-manager.useUserPackages = true;
  #      home-manager.extraSpecialArgs = { inherit user nur; };  # Pass flake variable
  #      home-manager.users.${user} = {
  #        imports = [(import ./work/home.nix) nur.nixosModules.nur];
  #      };
  #    }
  #  ];
  #};

  #other_system = nixpkgs.lib.nixosSystem {                 # more system profiles
  #  ...
  #};
}
