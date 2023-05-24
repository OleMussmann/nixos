{ inputs, ... }:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  # machine-id is used by systemd for the journal, if you don't
  # persist this file you won't be able to easily use journalctl to
  # look at journals for previous boots.
  #
  # If you want to run an openssh daemon, you may want to store the
  # host keys across reboots. For this to work you will need to
  # create the directory yourself:
  # $ mkdir /persist/etc/ssh
  environment = {
    etc = {
      "machine-id".source = "/persist/etc/machine-id";
      "ssh/ssh_host_rsa_key".source = "/persist/etc/ssh/ssh_host_rsa_key";
      "ssh/ssh_host_rsa_key.pub".source = "/persist/etc/ssh/ssh_host_rsa_key.pub";
      "ssh/ssh_host_ed25519_key".source = "/persist/etc/ssh/ssh_host_ed25519_key";
      "ssh/ssh_host_ed25519_key.pub".source = "/persist/etc/ssh/ssh_host_ed25519_key.pub";
    };
    persistence."/persist" = {
      directories = [
        "/var/lib/bluetooth"
        "/etc/NetworkManager/system-connections"
        "/etc/wireguard"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    # persist if user was lectured about `sudo` responsibilities
    "L /var/db/sudo/lectured - - - - /persist/var/db/sudo/lectured"
  ];

  fileSystems."/".neededForBoot = true;
  fileSystems."/home".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;
}

