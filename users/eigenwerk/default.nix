{ config, pkgs, lib, inputs, ... }:
let
  unstable-pkgs = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
  };

  mkObsidianPlugin = import ../../lib/obsidian-plugin.nix {
    inherit pkgs;
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

  xdg.mimeApps.defaultApplications = lib.genAttrs [
    "text/html"
    "application/xhtml+xml"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/about"
    "x-scheme-handler/unknown"
  ] (_: "firefox.desktop");

  programs.opencode = {
    enable = true;
  };

  programs.obsidian = {
    defaultSettings.communityPlugins = [
      (mkObsidianPlugin {
        repo = "siosig/obsidian-nextcloudsync";
        version = "1.0.13";
        hashes = {
          "main.js" = "sha256-qtbaW4enK7z7hSZD8gcAm39HT08WiUra9Cfg27pKdkQ=";
          "manifest.json" = "sha256-rDZu9ywSeE62Wrdw8h8E+gecM5vtNbw34RQCuq/CASw=";
          "styles.css" = "sha256-AI5y06XJcxgBj8IZ1PUrEn0XRVVeEL6boiO1E/prc1U=";
        };
      })
    ];
    vaults.zettelkasten = {
      target = "zettelkasten";
    };
  };

  home.stateVersion = "26.05";
}
