{ pkgs, ... }:
let
  deploy_user = "deploy";
in
{
  users.groups.${deploy_user} = { };
  users.extraUsers.${deploy_user} = {
    isSystemUser = true;
    group = "${deploy_user}";
    shell = pkgs.bash;

    openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIowh+y+0ozQh+dLj5VFGxh/s0WjvRCQEThRX6h+STzY ole@work''
    ];
  };

  nix.settings.trusted-users = [ "${deploy_user}" ];
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
