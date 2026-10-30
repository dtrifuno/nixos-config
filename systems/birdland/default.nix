{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/nixos/common.nix
      ../../modules/nixos/fonts.nix
      ../../modules/nixos/gc.nix
      ../../modules/nixos/sway.nix
      ../../modules/nixos/unfree.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "birdland"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Skopje";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "mk_MK.UTF-8";
    LC_IDENTIFICATION = "mk_MK.UTF-8";
    LC_MEASUREMENT = "mk_MK.UTF-8";
    LC_MONETARY = "mk_MK.UTF-8";
    LC_NAME = "mk_MK.UTF-8";
    LC_NUMERIC = "mk_MK.UTF-8";
    LC_PAPER = "mk_MK.UTF-8";
    LC_TELEPHONE = "mk_MK.UTF-8";
    LC_TIME = "mk_MK.UTF-8";
  };

  virtualisation.docker = {
    enable = true;
  };
  networking.firewall.trustedInterfaces = [ "docker0" "br-+" ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  users.groups.media = {};
  systemd.tmpfiles.rules = [
    "d /srv/music 2775 root media - -"
  ];

  users.users."eigenwerk" = {
    isNormalUser = true;
    description = "Home";
    extraGroups = [ "networkmanager" "wheel" "docker" "media" ];
  };

  home-manager.users.eigenwerk = {
    imports = [
      ../../users/eigenwerk/default.nix
      ../../modules/home-manager/music-production.nix
    ];
  };

  users.users."mi-c3" = {
    isNormalUser = true;
    description = "Work";
    extraGroups = [ "networkmanager" "wheel" "docker" "media" ];
  };

  home-manager.users."mi-c3" =
    import ../../users/mi-c3/default.nix;
}
