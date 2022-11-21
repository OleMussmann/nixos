{
  # Description, write anything or even nothing
  description = "NixOS tmpfs";

  # Input config, or package repos
  inputs = {
    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nixpkgs, NixOS's official repo
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

    # Nix Package Search
    nps.url = "github:OleMussmann/Nix-Package-Search";
  };

  # Output config, or config for NixOS system
  outputs = { self, nixpkgs, home-manager, nps, ... }@inputs:
  let
    user = "ole";
    location = "$HOME/.setup";
  in
  {
    nixosConfigurations = (                                 # NixOS configurations
      import ./hosts {                                      # Imports ./hosts/default.nix
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager user location;  # Also inherit home-manager so it does not need to be defined here.
        }
      );

  # You can define many systems in one Flake file.
  # NixOS will choose one based on your hostname.
  #
  # nixosConfigurations."nixos2" = nixpkgs.lib.nixosSystem {
  #   system = "x86_64-linux";
  #   modules = [
  #     ./configuration2.nix
  #   ];
  # };

  };
}
