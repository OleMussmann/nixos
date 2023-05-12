{ pkgs, ... }:
{
  users.users.groups.deploy = { };
  users.users.extraUsers.deploy = {
    isSystemUser = true;
    group = "deploy";
    shell = pkgs.bash;
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
