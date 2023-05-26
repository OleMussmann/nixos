{
  # Description, write anything or even nothing
  description = "NixOS tmpfs";

  # Input config, or package repos
  inputs = {
    # Nixpkgs, NixOS's official repo
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix Package Search
    nps.url = "github:OleMussmann/Nix-Package-Search/development";
    #nps.url = "github:OleMussmann/Nix-Package-Search";
    #nps.url = "path:/home/ole/bin/Nix-Package-Search";
    nps.inputs.nixpkgs.follows = "nixpkgs";

    # Entangled
    entangled.url = "github:entangled/entangled";
    entangled.inputs.nixpkgs.follows = "nixpkgs";

    # fzf_search
    fzf-search.url = "github:suvayu/fzf_search";
    fzf-search.inputs.nixpkgs.follows = "nixpkgs";

    # wipeclean
    wipeclean.url = "github:OleMussmann/wipeClean";
    wipeclean.inputs.nixpkgs.follows = "nixpkgs";

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Nix User Repository NUR
    nur.url = github:nix-community/NUR;
    
    # NixOS Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  # Output config, or config for NixOS system
  outputs = { self, nixpkgs, home-manager, nixos-hardware, nur, ... }@inputs:
  let
    overlays = final: prev: {
      unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system};
      out-of-tree = {
        nps = inputs.nps.defaultPackage.${prev.system};
        entangled = inputs.entangled.defaultPackage.${prev.system};
        fzf-search = inputs.fzf-search.packages.${prev.system}.fzf-search;
        wipeclean = inputs.wipeclean.packages.${prev.system}.wipeclean;
      };
    };
  in
  {
    nixosConfigurations =
      let
        hosts = builtins.readDir ./hosts;
        mkHost = path: nixpkgs.lib.nixosSystem (
          import path {
            inherit inputs nixpkgs self home-manager nixos-hardware overlays nur;
          }
        );
      in
      builtins.mapAttrs ( name: _: mkHost ./hosts/${name} ) hosts;
    };
}
