{ config, pkgs, inputs, system, user, overlays, ... }:
{
  users.users.${user}.shell = pkgs.fish;

  # add fish to /etc/shells
  # otherwise GDM does not show users with fish
  environment.shells = with pkgs; [ fish ];

  # enable completion for system packages like systemd
  environment.pathsToLink = [ "/share/fish" ];

  home-manager.users.${user} =
  {
    home.packages = with pkgs; [
      any-nix-shell    # use fish in nix-shell

      # fish plugins
      fishPlugins.autopair-fish      # helper for brackets and quotation marks
      fishPlugins.colored-man-pages  # yay, colors!
      fishPlugins.sponge             # remove failed commands from history
    ];
    programs = {
      fish = {
        enable = true;
        functions = {
          take = "mkdir -p \"$argv\"; and cd \"$argv[-1]\"";
        };
        shellAbbrs = {
          ll = "ls -l";
        };
        shellAliases = {
          trash = "gio trash";
          update = "nix flake update --commit-lock-file /home/ole/.system";
          upgrade = "sudo nixos-rebuild switch --flake /home/ole/.system &&
            nvd diff $(ls -d1v /nix/var/nix/profiles/system-*-link | tail -n 2)";
        };
        interactiveShellInit = ''
          set fish_greeting ""
          fish_vi_key_bindings
          any-nix-shell fish | source
        '';
      };
    };
  };
}
