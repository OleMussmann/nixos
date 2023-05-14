{ pkgs, config, user, ... }:
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
        todoist-electron # Todo app
        transmission     # Torrent client
        xorg.xkill       # Kill applications

        # Applications from unstable channel
        unstable.pika-backup      # borg frontend
        #unstable.logseq           # knowledge base

        # Rollbacks
        (callPackage ../../rollbacks/logseq-0.9.0 {})           # knowledge base

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
  programs = {
    partition-manager.enable = true;
  };
}


