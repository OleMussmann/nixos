{ pkgs, user, ... }:
{
  home-manager.users.${user} = {
    home = {
      packages = with pkgs; [
        appimage-run     # Runs AppImages on NixOS
        chromium         # Browser
        ffmpeg           # Video support
        gimp             # Graphical editor
        inkscape         # Vector graphical editor
        keepassxc        # Password manager
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
      ];
    };
  };
}



