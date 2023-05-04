{ pkgs, ... }:

{
  services = {
    # Enable fingerprint reader support
    fprintd.enable = true;
    fprintd.tod.enable = true;
    fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
  };
}
