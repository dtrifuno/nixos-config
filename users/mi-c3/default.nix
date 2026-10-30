{ config, pkgs, lib, inputs, ... }:
let
  unstable-pkgs = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;

    config.allowUnfreePredicate = pkgs.config.allowUnfreePredicate;
  };
in
{
  imports = [
    ../../modules/home-manager/desktop.nix
    ../../modules/home-manager/catppuccin-mocha.nix
  ];

  programs.git = {
    settings = {
      user = {
        name = "Darko Trifunovski";
        email = "darko.trifunovski@mi-c3.com";
      };
    };
  };

  programs.chromium = {
    extensions = [
      "didegimhafipceonhjepacocaffmoppf" # Passbolt
    ];
  };

  programs.vscodium = {
    profiles.default = {
      extensions = with unstable-pkgs.vscode-extensions; [
        anthropic.claude-code
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "cucumber-official";
          publisher = "CucumberOpen";
          version = "1.11.0";
          sha256 = "sha256-+fq9ramZCHtXpu/JhxsoSiVD3usQAY03L+msPFZC07c=";
        }
      ];
    };
  };

  programs.claude-code = {
    enable = true;
    package = unstable-pkgs.claude-code;
  };

  home.stateVersion = "26.05";
}
