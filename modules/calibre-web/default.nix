{ user, ... }:
{
  services.calibre-web = {
    enable = true;
    user = "ole";
    group = "users";
    listen = {
      ip = "127.0.0.1";
      port = 8083;
    };
    options = {
      enableBookConversion = true;
      enableBookUploading = true;
      calibreLibrary = "/home/ole/calibre_library";
    };
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
    #publish = {
    #  enable = true;
    #  addresses = true;
    #  domain = true;
    #  hinfo = true;
    #  userServices = true;
    #  workstation = true;
    #};
  };
  services.nginx = {
    enable = true;
    virtualHosts."pintsize" = {
      locations."/calibre" = {
        extraConfig = ''
          proxy_pass http://127.0.0.1:8083;
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Scheme $scheme;
          proxy_set_header X-Script-Name /calibre;
        '';
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 ];
}
