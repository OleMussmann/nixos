{ inputs, nixpkgs, home-manager, nixos-hardware, overlays, nur, ... }:
{
  x =
  [
    import ./work
    import ./nixos-vm
  ];
}
