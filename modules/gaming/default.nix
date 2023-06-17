{ pkgs, ... }:
{
  # Steam
  programs.steam = {
    enable = true;
    #remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Lutris
  environment.systemPackages = with pkgs; [
    (lutris.override {
      extraLibraries =  pkgs: [
        # List library dependencies here
      ];
      extraPkgs = pkgs: [
         # List package dependencies here
       ];
     })
   ];
   hardware.opengl.driSupport32Bit = true;
 }
