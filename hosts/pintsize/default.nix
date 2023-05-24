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
      ../../modules/impermanence

      ../../modules/docker
      ../../modules/fish
      ../../modules/git
      ../../modules/neo_layout
      ../../modules/neovim
      ../../modules/nix
      ../../modules/remote_deploy
      ../../modules/starship
      ../../modules/tailscale

      # old bios, does not support changing EFI vars
      ({ pkgs, ... }: { boot.loader.efi.canTouchEfiVariables = pkgs.lib.mkForce true; })

      # authorized SSH key login
      ({ ... }: {
        users.extraUsers.ole.openssh.authorizedKeys.keys = [
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIowh+y+0ozQh+dLj5VFGxh/s0WjvRCQEThRX6h+STzY ole@work''  # nixos work laptop
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOhchwfyk9oy8QX7U/fJsrgH5DuQvomUpvpi6qKf/ozw ole@isbjorngames.com''  # ubuntu private PC
        ];
      })

      # authorized SSH key for remote_deploy
      ({ ... }: {
        users.extraUsers.deploy.openssh.authorizedKeys.keys = [
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIowh+y+0ozQh+dLj5VFGxh/s0WjvRCQEThRX6h+STzY ole@work''  # nixos work laptop
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOhchwfyk9oy8QX7U/fJsrgH5DuQvomUpvpi6qKf/ozw ole@isbjorngames.com''  # ubuntu private PC
        ];
      })

      # Only use SSH via keys
      ({ ... }: {
        services.openssh = {
            passwordAuthentication = false;
            kbdInteractiveAuthentication = false;
            permitRootLogin = "no";
          };
      })

      # configure a borg backup server
      ({ ... }: {
        services.borgbackup.repos = {
          my_borg_repo = {
            authorizedKeys = [
              ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIowh+y+0ozQh+dLj5VFGxh/s0WjvRCQEThRX6h+STzY ole@work''
              ] ;
              path = "/backups/ole/nixos-work-laptop" ;
            };
          };
      })

      home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
      }
    ];
  };
}
