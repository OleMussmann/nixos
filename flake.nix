{
  # Description, write anything or even nothing
  description = "NixOS tmpfs";

  # Input config, or package repos
  inputs = {
    # Nixpkgs, NixOS's official repo
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix Package Search
    nps.url = "github:OleMussmann/Nix-Package-Search";
    nps.inputs.nixpkgs.follows = "nixpkgs";
    
    # NixOS Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  # Output config, or config for NixOS system
  outputs = { self, nixpkgs, nixos-hardware, home-manager, ... }@inputs:
  let
    user = "ole";
    overlays-third-party = final: prev: {
      # Let's give third-party packages their own 'third-party'
      # attribute not shadow possible existing packages.
      third-party = {
        nps = inputs.nps.defaultPackage.${prev.system};
      };
    };
  in
  {
    nixosConfigurations = (                                 # NixOS configurations
      import ./hosts {                                      # Imports ./hosts/default.nix
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager user nixos-hardware overlays-third-party;  # Also inherit home-manager so it does not need to be defined here.
        }
      );
  };
}
