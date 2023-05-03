{ pkgs, user, ... }:
{
  home-manager.users.${user} = {
    home = {
      packages = with pkgs; [
        appimage-run     # Runs AppImages on NixOS
        chromium         # Browser
        ffmpeg           # Video support
        gimp             # Graphical editor
        handbrake        # Encoder
        inkscape         # Vector graphical editor
        keepassxc        # Password manager
        libreoffice      # Office packages
        nextcloud-client # File sync
        pika-backup      # borg frontend
        transmission     # Torrent client
        xorg.xkill       # Kill applications

        # Applications from unstable channel
        unstable.logseq           # knowledge base

        # Applications from out-of-tree repos
        out-of-tree.entangled
        out-of-tree.fzf-search
        out-of-tree.wipeclean
      ]
      ++ (
        # Install dconf2nix if GNOME is used
        if config.services.xserver.desktopManager.gnome.enable then [
          dconf2nix
        ]
        else []
      );
    };
  };
}


