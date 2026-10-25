{ config, pkgs, ... }:

{
  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 5;

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Optimize storage
  nix.settings.auto-optimise-store = true;
}
