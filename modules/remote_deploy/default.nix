{ pkgs, ... }:
{
  users.groups.deploy = { };
  users.extraUsers.deploy = {
    isSystemUser = true;
    group = "deploy";
    shell = pkgs.bash;

    openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIowh+y+0ozQh+dLj5VFGxh/s0WjvRCQEThRX6h+STzY ole@work''
    ];
  };

  security.sudo.extraRules = [
    {
      groups = [ "deploy" ];
      commands = [
        {
          command = "/nix/store/*/bin/switch-to-configuration";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/nix-store";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/nix-env";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
