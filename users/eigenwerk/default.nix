{ config, pkgs, lib, inputs, ... }:
let
  unstable-pkgs = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
  };
in
{
  imports = [
    ../../modules/home-manager/desktop.nix
    ../../modules/home-manager/gruvbox.nix
  ];

  programs.git = {
    settings = {
      user = {
        name = "Darko Trifunovski";
        email = "dtrifuno@gmail.com";
      };
    };
  };

  programs.opencode = {
    enable = true;
  };

  home.stateVersion = "26.05";
}
