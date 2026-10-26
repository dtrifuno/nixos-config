{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Skopje";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  programs.nix-ld.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    neovim
    ripgrep
    git
    curl
    wget
  ];

  environment.variables.EDITOR = "nvim";

  system.stateVersion = "26.05";
}
