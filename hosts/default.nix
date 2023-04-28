{ inputs, nixpkgs, home-manager, nixos-hardware, overlays, nur, ... }:
#{ inputs, nixpkgs, home-manager, user, nixos-hardware, overlays, ... }:

{
  nixos-vm = nixpkgs.lib.nixosSystem {                      # VM profile
    user = "ole";
    system = "x86_64-linux";                                # System architecture
    specialArgs = { inherit inputs; };                 # Pass flake variable
    modules = [                                             # Modules that are used
      ({ config, pkgs, ... }: {
        nixpkgs.overlays = [
          overlays
        ];
      })
      nur.nixosModules.nur
      ./nixos-vm
      ./shared.nix

      home-manager.nixosModules.home-manager rec {              # Home-Manager module that is used.
        inherit user;
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
    user = "ole2";
    system = "x86_64-linux";                                # System architecture
    specialArgs = { inherit inputs user; };                 # Pass flake variable
    modules = [                                             # Modules that are used
      ({ config, pkgs, ... }: {
        nixpkgs.overlays = [
          overlays
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
