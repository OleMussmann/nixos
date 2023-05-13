{ pkgs, ... }:
{

  users.users.root = {
    isNormalUser = true;
    passwordFile = "/persist/passwords/root";
    shell = pkgs.bash;

    openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIowh+y+0ozQh+dLj5VFGxh/s0WjvRCQEThRX6h+STzY ole@work''
    ];
  };

  #nix.settings.trusted-users = [ "${deploy_user}" ];
  #security.sudo.extraRules = [
  #  {
  #    groups = [ "deploy" ];
  #    commands = [
  #      {
  #        command = "/nix/store/*/bin/switch-to-configuration";
  #        options = [ "NOPASSWD" ];
  #      }
  #      {
  #        command = "/run/current-system/sw/bin/nix-store";
  #        options = [ "NOPASSWD" ];
  #      }
  #      {
  #        command = "/run/current-system/sw/bin/nix-env";
  #        options = [ "NOPASSWD" ];
  #      }
  #      {
  #        command = "${pkgs.systemd}/bin/systemctl";
  #        options = [ "NOPASSWD" ];
  #      }
  #      #{
  #      #  command = "${pkgs.systemd}/bin/systemctl start '/dev-disk-by*.swap'";
  #      #  options = [ "NOPASSWD" ];
  #      #}
  #      #{
  #      #  command = "${pkgs.systemd}/bin/systemctl start '/dev-disk-by*.device'";
  #      #  options = [ "NOPASSWD" ];
  #      #}
  #    ];
  #  }
  #];
}
