{ inputs, nixpkgs, home-manager, user, nixos-hardware, overlays-third-party, overlay-unstable, nur, ... }:
#{ inputs, nixpkgs, home-manager, user, nixos-hardware, overlays, ... }:

{
  nixos-vm = nixpkgs.lib.nixosSystem {                      # VM profile
    system = "x86_64-linux";                                # System architecture
    specialArgs = { inherit inputs user; };                 # Pass flake variable
    modules = [                                             # Modules that are used
      ({ config, pkgs, ... }: {
        nixpkgs.overlays = [
          overlays-third-party
          overlay-unstable
        ];
      })
      nur.nixosModules.nur
      ./nixos-vm
      ./shared.nix

      home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user nur; };  # Pass flake variable
        home-manager.users.${user} = {
          imports = [(import ./nixos-vm/home.nix) nur.nixosModules.nur];
        };
      }
    ];
  };

  work = nixpkgs.lib.nixosSystem {                          # work profile
    system = "x86_64-linux";                                # System architecture
    specialArgs = { inherit inputs user; };                 # Pass flake variable
    modules = [                                             # Modules that are used
      ({ config, pkgs, ... }: {
        nixpkgs.overlays = [
          overlays-third-party
          overlay-unstable
        ];
      })
      nixos-hardware.nixosModules.dell-xps-13-9310          # Hardware support
      nur.nixosModules.nur
      ./work
      ./shared.nix

      home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user nur; };  # Pass flake variable
        home-manager.users.${user} = {
          imports = [(import ./work/home.nix) nur.nixosModules.nur];
        };
      }
    ];
  };

  #other_system = nixpkgs.lib.nixosSystem {                 # more system profiles
  #  ...
  #};
}
