{ config, pkgs, lib, inputs, ... }:
let
  unstable-pkgs = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
  };
in
{
  programs.alacritty = {
    theme = "catppuccin_mocha";
  };

  wayland.windowManager.sway = {
    config = {
      bars = [{
        position = "top";
        statusCommand = "i3status-rs ${config.home.homeDirectory}/${config.xdg.configFile."i3status-rust/config-top.toml".target}";
        extraConfig = "workspace_min_width 28\ntray_padding 4";
        fonts = {
          names = [ "FiraCode Nerd Font" ];
          style = "Semibold";
          size = 10.5;
        };
        colors = {
          background = "#313244"; # surface0
          statusline = "#cdd6f4"; # text
          separator = "#6c7086"; # overlay0
          focusedBackground = "#1e1e2e"; # base
          focusedStatusline = "#cdd6f4"; # text
          focusedSeparator = "#1e1e2e"; # base
          focusedWorkspace = {
            border = "#1e1e2e"; # base
            background = "#cba6f7"; # mauve
            text = "#11111b"; # crust
          };
          activeWorkspace = {
            border = "#1e1e2e"; # base
            background = "#585b70"; # surface2
            text = "#cdd6f4"; # text
          };
          inactiveWorkspace = {
            border = "#1e1e2e"; # base
            background = "#1e1e2e"; # base
            text = "#cdd6f4"; # text
          };
          urgentWorkspace = {
            border = "#1e1e2e"; # base
            background = "#f38ba8"; # red
            text = "#11111b"; # crust
          };
          bindingMode = {
            border = "#1e1e2e"; # base
            background = "#fab387"; # peach
            text = "#11111b"; # crust
          };
        };
      }];
      colors = {
        background = "#1e1e2e"; # base
        focused = {
          border = "#b4befe"; # lavender
          background = "#1e1e2e"; # base
          text = "#cdd6f4"; # text
          indicator = "#f5e0dc"; # rosewater
          childBorder = "#b4befe"; # lavender
        };
        focusedInactive = {
          border = "#6c7086"; # overlay0
          background = "#1e1e2e"; # base
          text = "#cdd6f4"; # text
          indicator = "#f5e0dc"; # rosewater
          childBorder = "#6c7086"; # overlay0
        };
        unfocused = {
          border = "#6c7086"; # overlay0
          background = "#1e1e2e"; # base
          text = "#cdd6f4"; # text
          indicator = "#f5e0dc"; # rosewater
          childBorder = "#6c7086"; # overlay0
        };
        urgent = {
          border = "#fab387"; # peach
          background = "#1e1e2e"; # base
          text = "#fab387"; # peach
          indicator = "#6c7086"; # overlay0
          childBorder = "#fab387"; # peach
        };
        placeholder = {
          border = "#6c7086"; # overlay0
          background = "#1e1e2e"; # base
          text = "#cdd6f4"; # text
          indicator = "#6c7086"; # overlay0
          childBorder = "#6c7086"; # overlay0
        };
      };
    };
  };

  programs.i3status-rust = {
    bars.top.settings.theme = {
      theme = "ctp-mocha";
      overrides = {
        idle_bg = "#313244";     # surface0
        idle_fg = "#cdd6f4";     # text
        info_bg = "#313244";     # surface0
        info_fg = "#89b4fa";     # blue
        good_bg = "#313244";     # surface0
        good_fg = "#a6e3a1";     # green
        warning_bg = "#313244";  # surface0
        warning_fg = "#f9e2af";  # yellow
        critical_bg = "#313244"; # surface0
        critical_fg = "#f38ba8"; # red
        separator_bg = "auto";
        separator_fg = "auto";
      };
    };
  };

  programs.rofi = {
    theme = let
      catppuccin-rofi = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "rofi";
        rev = "71fb15577ccb091df2f4fc1f65710edbc61b5a53";
        hash = "sha256-81eeFjwM/haPjIEWkZPp1JSDwhWbWDAuKtWiCg7P9Q0=";
      };
    in {
      "@theme" = "${catppuccin-rofi}/catppuccin-default.rasi";
      "@import" = "${catppuccin-rofi}/themes/catppuccin-mocha.rasi";
    };
  };

  programs.chromium = {
    extensions = [
      "bkkmolkhemgaeaeggcmfbghljjjoofoh" # Catppuccin Mocha
    ];
  };

  programs.firefox = {
    profiles.default = {
      extensions.packages =
        with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          firefox-color
        ];
    };
  };

  programs.neovim = {
    plugins = [
      {
         plugin = pkgs.vimPlugins.catppuccin-nvim;
         type = "lua";
         config = ''
           require("catppuccin").setup({
             flavour = "mocha",
           })
         '';
      }
    ];

    extraConfig = lib.mkAfter ''
      " Colorscheme
      set termguicolors
      set background=dark
      colorscheme catppuccin-mocha
    '';
  };

  programs.vscodium = {
    profiles.default = {
      extensions = with unstable-pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
      ];
      userSettings = {
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";
      };
    };
  };
}
