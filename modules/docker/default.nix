{ user, ... }:
{
  virtualisation = {
    docker.enable = true;

    # WORKAROUND
    # disable restarting dockerd without affecting running container
    # this prevents a long wait for process s6-svscan during shutdown
    docker.liveRestore = false;
  };

  users.users.${user} = {
    extraGroups = [
      "docker"
    ];
  };
}

