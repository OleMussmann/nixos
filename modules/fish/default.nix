{ pkgs, user, ... }:
{
  users.users.${user}.shell = pkgs.fish;
  programs.fish.enable = true;

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
          update = "nix flake update --commit-lock-file /home/${user}/.system";
          upgrade = "sudo nixos-rebuild switch --flake /home/${user}/.system &&
            nvd diff $(ls -d1v /nix/var/nix/profiles/system-*-link | tail -n 2)";
        };
        interactiveShellInit = ''
          set fish_greeting ""
          fish_vi_key_bindings
          any-nix-shell fish | source

          mcfly init fish | source
          mcfly_key_bindings
        '';
      };
      mcfly = {
        enable = true;
        fuzzySearchFactor = 2;
        keyScheme = "vim";
      };
    };
  };
}
