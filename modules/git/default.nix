{ user, ... }:
{
  home-manager.users.${user} =
  {
    programs.git = {
      enable = true;
      userName  = "Ole Mussmann";
      userEmail = "gitlab+account@ole.mn";
      diff-so-fancy.enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        diff.tool = "vimdiff3";
        difftool.vimdiff3.path = "nvim";
        merge.tool = "vimdiff";
        merge.conflictStyle = "diff3";
      };
    };
  };
}
