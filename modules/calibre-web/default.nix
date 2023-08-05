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
    publish = {
      enable = true;
      domain = true;
    };
  };
  services.nginx = {
    enable = true;
    virtualHosts."pintsize.local" = {
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
  services.tailscale.useRoutingFeatures = "server";
  networking.firewall.allowedTCPPorts = [ 80 ];
}
