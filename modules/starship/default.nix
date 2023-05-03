{ user, lib, ... }:
{
  home-manager.users.${user} =
  {
    programs.starship = {
      enable = true;
      settings = {
        format = lib.concatStrings [
          "$directory"
          "$all"
        ];
        right_format = lib.concatStrings [
          "$git_branch"
          "$git_status"
          "$cmd_duration"
        ];
        add_newline = false;
        #linebreak.disabled = true;
        character = {
          success_symbol = " [](#6791c9)";
          error_symbol = " [](#df5b61)";
          vicmd_symbol = "[  ](#78b892)";
        };
        custom = {
          direnv = {
            command = "nix flake metadata --json 2>/dev/null | jq '.description' | sed -e 's/\"//g'; if [ \"\$\{PIPESTATUS[0]\}\" != \"0\" ]; then basename \"$PWD\"; fi ";
            shell = "bash";
            format = "[$symbol$output]($style)";
            style = "fg:bold green";
            symbol = "📁 ";
            when = "env | grep -E '^DIRENV_FILE='";
          };
        };
        hostname = {
          ssh_only = true;
          format = "[$hostname](bold blue) ";
          disabled = false;
        };
        cmd_duration = {
          #min_time = 1;
          format = "[](fg:#1c252c bg:none)[$duration]($style)[](fg:#1c252c bg:#1c252c)[](fg:#bc83e3 bg:#1c252c)[ ](fg:#1c252c bg:#bc83e3)[](fg:#bc83e3 bg:none) ";
          disabled = false;
          style = "fg:#d9d7d6 bg:#1c252c";
        };
        directory = {
          format = "[](fg:#1c252c bg:none)[$path]($style)[](fg:#1c252c bg:#1c252c)[](fg:#6791c9 bg:#1c252c)[ ](fg:#1c252c bg:#6791c9)[](fg:#6791c9 bg:none)";
          style = "fg:#d9d7d6 bg:#1c252c";
          truncation_length = 3;
          truncate_to_repo = false;
        };
        git_branch = {
          format = "[](fg:#1c252c bg:none)[$branch]($style)[](fg:#1c252c bg:#1c252c)[](fg:#78b892 bg:#1c252c)[](fg:#282c34 bg:#78b892)[](fg:#78b892 bg:none) ";
          style = "fg:#d9d7d6 bg:#1c252c";
        };
        git_status = {
          format="[](fg:#1c252c bg:none)[$all_status$ahead_behind]($style)[](fg:#1c252c bg:#1c252c)[](fg:#67afc1 bg:#1c252c)[ ](fg:#1c252c bg:#67afc1)[](fg:#67afc1 bg:none) ";
          style = "fg:#d9d7d6 bg:#1c252c";
          conflicted = "=";
          ahead = "⇡\${count}";
          behind = "⇣\${count}";
          diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
          up_to_date = "";
          untracked = "?\${count}";
          stashed = "";
          modified = "!\${count}";
          staged = "+\${count}";
          renamed = "»\${count}";
          deleted = "\${count}";
        };
        git_commit = {
          format = "[\\($hash\\)]($style) [\\($tag\\)]($style)";
          style = "green";
        };
        git_state = {
          rebase = "REBASING";
          merge = "MERGING";
          revert = "REVERTING";
          cherry_pick = "CHERRY-PICKING";
          bisect = "BISECTING";
          am = "AM";
          am_or_rebase = "AM/REBASE";
          style = "yellow";
          format = "([\$state( \$progress_current/\$progress_total)](\$style)) ";
        };
      };
    };
  };
}
