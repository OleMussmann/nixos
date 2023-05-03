{ user, ... }:
{
  home-manager.users.${user} =
  {
    programs.git = {
      enable = true;
      userName  = "Ole Mussmann";
      userEmail = "gitlab+account@ole.mn";
    };
  };
}
