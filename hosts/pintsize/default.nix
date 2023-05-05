
{ inputs, nixpkgs, home-manager, overlays, nur, ... }:
{
  pintsize =
  let
    user = "ole";
    hostname = "pintsize";
    system = "x86_64-linux";
    timezone = "Europe/Amsterdam";
    defaultlocale = "en_US.UTF-8";
  in
  nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs user overlays nur hostname timezone defaultlocale; };                 # Pass flake variable
    modules = [                                             # Modules that are used
      ./hardware-configuration.nix
      ../../modules/base
      ../../modules/desktop
      ../../modules/impermanence

      ../../modules/docker
      ../../modules/fish
      ../../modules/git
      ../../modules/neo_layout
      ../../modules/neovim
      ../../modules/nix
      ../../modules/starship

      home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
      }
    ];
  };
}