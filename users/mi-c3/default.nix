{ config, pkgs, lib, inputs, ... }:
let
  unstable-pkgs = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;

    config.allowUnfreePredicate = pkgs.config.allowUnfreePredicate;
  };

  mkObsidianPlugin = import ../../lib/obsidian-plugin.nix {
    inherit pkgs;
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

  xdg.mimeApps.defaultApplications = lib.genAttrs [
    "text/html"
    "application/xhtml+xml"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/about"
    "x-scheme-handler/unknown"
  ] (_: "chromium-browser.desktop");

  programs.vscodium = {
    profiles.default = {
      userSettings = {
        "claudeCode.hideOnboarding" = true;
      };
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
    vaults.notes = {
      target = "notes";
    };
  };

  home.stateVersion = "26.05";
}
