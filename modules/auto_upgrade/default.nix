{ ... }:
{
  system.autoUpgrade = {
    enable = true;
    flake = "gitlab:OleMussmann/nixos";
    flags = [
      "--no-write-lock-file"  # don't try to write to remote repo
    ];
    dates = "*-*-* 02:00:00"; # daily at 2am
    allowReboot = true;
    rebootWindow = {          # reboot allowed between
      lower = "02:00";
      upper = "04:00";
    };
  };
}
