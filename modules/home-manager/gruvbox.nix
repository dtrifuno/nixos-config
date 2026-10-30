{ config, pkgs, lib, inputs, ... }:
let
  unstable-pkgs = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
  };

  wallpapers = import ../../packages/wallpapers.nix {
    inherit pkgs;
  };
in
{
  programs.alacritty = {
    theme = "gruvbox_material_medium_dark";
  };

  wayland.windowManager.sway = {
    config = {
      output = {
        "*".bg = "${wallpapers}/share/wallpapers/gruvbox/forest-river.jpg fill";
        "Dell Inc. DELL G2724D HCP06Y3" = {
          bg = "${wallpapers}/share/wallpapers/gruvbox/forest-river.jpg fill";
        };
        "Dell Inc. DELL G2724D 1DP06Y3" = {
          bg = "${wallpapers}/share/wallpapers/gruvbox/forest-spring.jpg fill";
        };
      };
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
          background = "#3c3836"; # bg1
          statusline = "#ebdbb2"; # fg
          separator = "#928374"; # gray
          focusedBackground = "#282828"; # bg0
          focusedStatusline = "#ebdbb2"; # fg
          focusedSeparator = "#282828"; # bg0
          focusedWorkspace = {
            border = "#282828"; # bg0
            background = "#d79921"; # yellow
            text = "#282828"; # bg0
          };
          activeWorkspace = {
            border = "#282828"; # bg0
            background = "#504945"; # bg2
            text = "#ebdbb2"; # fg
          };
          inactiveWorkspace = {
            border = "#282828"; # bg0
            background = "#282828"; # bg0
            text = "#a89984"; # fg2
          };
          urgentWorkspace = {
            border = "#282828"; # bg0
            background = "#cc241d"; # red
            text = "#fbf1c7"; # fg0
          };
          bindingMode = {
            border = "#282828"; # bg0
            background = "#fe8019"; # orange
            text = "#282828"; # bg0
          };
        };
      }];
      colors = {
        background = "#282828"; # bg0
        focused = {
          border = "#458588"; # blue
          background = "#282828"; # bg0
          text = "#ebdbb2"; # fg
          indicator = "#d79921"; # yellow
          childBorder = "#458588"; # blue
        };
        focusedInactive = {
          border = "#665c54"; # bg3
          background = "#282828"; # bg0
          text = "#a89984"; # fg2
          indicator = "#d79921"; # yellow
          childBorder = "#665c54"; # bg3
        };
        unfocused = {
          border = "#504945"; # bg2
          background = "#282828"; # bg0
          text = "#a89984"; # fg2
          indicator = "#928374"; # gray
          childBorder = "#504945"; # bg2
        };
        urgent = {
          border = "#cc241d"; # red
          background = "#282828"; # bg0
          text = "#fb4934"; # bright red
          indicator = "#fe8019"; # orange
          childBorder = "#cc241d"; # red
        };
        placeholder = {
          border = "#504945"; # bg2
          background = "#282828"; # bg0
          text = "#a89984"; # fg2
          indicator = "#928374"; # gray
          childBorder = "#504945"; # bg2
        };
      };
    };
  };

  programs.i3status-rust = {
    bars.top.settings.theme = {
      theme = "gruvbox-dark";
      overrides = {
        idle_bg = "#3c3836";     # bg1
        idle_fg = "#ebdbb2";     # fg
        info_bg = "#3c3836";     # bg1
        info_fg = "#83a598";     # bright blue
        good_bg = "#3c3836";     # bg1
        good_fg = "#b8bb26";     # green
        warning_bg = "#3c3836";  # bg1
        warning_fg = "#fabd2f";  # bright yellow
        critical_bg = "#3c3836"; # bg1
        critical_fg = "#fb4934"; # bright red
        separator_bg = "auto";
        separator_fg = "auto";
      };
    };
  };

  programs.chromium = {
    extensions = [
      "giokfhncgfjkoamdbhfhfhgpikaioccc" # Gruvbox Slate
    ];
  };

  programs.firefox = {
    profiles.default = {
      extensions.packages =
        with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          gruvbox-dark-theme
        ];
    };
  };

  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      gruvbox-material
    ];

    extraConfig = lib.mkAfter ''
      " Colorscheme
      set termguicolors
      set background=dark
      let g:gruvbox_material_background = 'medium'
      let g:gruvbox_material_foreground = 'material'
      let g:gruvbox_material_better_performance = 1
      colorscheme gruvbox-material
    '';
  };

  programs.vscodium = {
    profiles.default = {
      extensions = with unstable-pkgs.vscode-extensions; [
        jdinhlife.gruvbox
      ];
      userSettings = {
        "workbench.colorTheme" = "Gruvbox Dark Medium";
      };
    };
  };

  programs.opencode = {
    tui = {
      theme = "gruvbox";
    };
  };
}
