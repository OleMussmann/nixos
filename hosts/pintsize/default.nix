{ self, inputs, nixpkgs, home-manager, overlays, nur, ... }:
let
  user = "ole";
  hostname = "pintsize";
  timezone = "Europe/Amsterdam";
  defaultlocale = "en_US.UTF-8";
in
{
  specialArgs = { inherit self inputs user overlays nur hostname timezone defaultlocale; };                 # Pass flake variable
  modules = [                                             # Modules that are used
    ./hardware-configuration.nix
    ../../modules/auto_upgrade
    ../../modules/base
    ../../modules/impermanence

    ../../modules/calibre-web
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
      services.openssh.settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
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
}
