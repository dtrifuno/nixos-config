
{ config, inputs, lib, osConfig, pkgs, ... }:

let
  hostname = osConfig.networking.hostName;

  sway_kb_identifier = {
    blue-note = "1:1:AT_Translated_Set_2_keyboard";
    birdland = "5426:101:Razer_Razer_Basilisk_Essential";
  }.${hostname} or "1:1:AT_Translated_Set_2_keyboard";

  has_battery = hostname == "blue-note";

  unstable-pkgs = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = pkgs.config.allowUnfree;
  };
in
{
  home.packages = with pkgs; [
    cliphist
    swaybg
    mako
    nemo
    vlc
    zotero
    grim
    sway-contrib.grimshot
    wl-clipboard
    meld
    (pkgs.fooyin.override { libvgm = null; })
    imagemagick
    filezilla
  ];

  programs.git = {
    enable = true;
    settings = {
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraConfig = ''
      " Use spaces instead of tabs
      set expandtab
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4
      set smartindent

      " Per-filetype indentation for 2-space languages
      augroup filetype_indent
        autocmd!
        autocmd FileType nix,javascript,javascriptreact,typescript,typescriptreact,html,css,scss,json,yaml
        \ setlocal tabstop=2 shiftwidth=2 softtabstop=2
      augroup END

      " Show tabs and trailing whitespace
      set list
      set listchars=tab:»\ ,trail:·,nbsp:␣

    '';
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -U fish_greeting
      function fish_right_prompt
        echo (set_color brgreen)"$USER"(set_color normal)@(hostname)
      end
    '';
    plugins = [
      {
        name = "hydro";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "hydro";
          rev = "f130b55ee3eaf099eccf588e2a62e5447068d120";
          hash = "sha256-0MMiM0NRbjZPJLAMDXb+Frgm+du80XpAviPqkwoHjDA=";
        };
      }
    ];
  };

  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = {
        program = "fish";
      };
      window = {
        padding = { x = 10; y = 5; };
        dynamic_padding = true;
        opacity = 0.95;
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      defaultWorkspace = "workspace number 1";
      startup = [
        { command = "mako"; }
        { command = "wl-paste --type text --watch cliphist store"; }
        { command = "wl-paste --type image --watch cliphist store"; }
        { command = "${pkgs.writeShellScript "keepassxc-unlock" ''
          ${pkgs.libsecret}/bin/secret-tool lookup keepassxc main  \
            | ${pkgs.keepassxc}/bin/keepassxc --pw-stdin "$HOME/password-db/passwords.kdbx"
        ''}";
        }
      ];
      workspaceOutputAssign = [
        { workspace = "1"; output = "Dell Inc. DELL G2724D HCP06Y3"; }
        { workspace = "2"; output = "Dell Inc. DELL G2724D HCP06Y3"; }
        { workspace = "3"; output = "Dell Inc. DELL G2724D HCP06Y3"; }
        { workspace = "4"; output = "Dell Inc. DELL G2724D HCP06Y3"; }
        { workspace = "5"; output = "Dell Inc. DELL G2724D HCP06Y3"; }
        { workspace = "6"; output = "Dell Inc. DELL G2724D 1DP06Y3"; }
        { workspace = "7"; output = "Dell Inc. DELL G2724D 1DP06Y3"; }
        { workspace = "8"; output = "Dell Inc. DELL G2724D 1DP06Y3"; }
        { workspace = "9"; output = "Dell Inc. DELL G2724D 1DP06Y3"; }
        { workspace = "10"; output = "Dell Inc. DELL G2724D 1DP06Y3"; }
      ];
      output = {
        "Dell Inc. DELL G2724D HCP06Y3" = {
          pos = "0 0";
        };
        "Dell Inc. DELL G2724D 1DP06Y3" = {
          pos = "2560 0";
        };
      };
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "rofi";
      window = {
        titlebar = false;
        border = 2;
      };
      gaps = {
        inner = 5;
        outer = 4;
      };
      input = {
        "type:keyboard" = {
          xkb_layout = "us,mk";
          xkb_options = "grp:alt_shift_toggle";
        };
      };
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
        menu = config.wayland.windowManager.sway.config.menu;
        terminal = config.wayland.windowManager.sway.config.terminal;
      in {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+q" = "kill";
        "${modifier}+r" = "exec ${menu} -show drun";
        "${modifier}+w" = "exec ${menu} -show window";

        "${modifier}+c" = "exec ${menu} -modi clipboard:cliphist-rofi-img -show clipboard -show-icons";
        "${modifier}+Shift+c" = "exec cliphist wipe";

        "${modifier}+p" = "exec grimshot savecopy area";
        "${modifier}+Shift+p" = "exec grimshot copy area";

        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";

        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";

        "${modifier}+h" = "split h";
        "${modifier}+v" = "split v";
        "${modifier}+f" = "fullscreen toggle";

        "${modifier}+s" = "layout stacking";
        "${modifier}+t" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space" = "focus mode_toggle";

        "${modifier}+a" = "focus parent";

        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+minus" = "scratchpad show";

        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";

    "${modifier}+Shift+e" = 
      "exec swaynag -t warning -m 'Do you want to exit sway?' -b 'Yes' 'swaymsg exit'";
      };
    }; 
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      top = {
        blocks = [
          {
            block = "cpu";
            format = " $icon $utilization";
          }
          {
            block = "memory";
            format = " $icon $mem_used_percents.eng(w:2)";
          }
          {
            block = "disk_space";
            path = "/";
            info_type = "used";
            interval = 20;
            warning = 80.0;
            alert = 90.0;
            format = " $icon $percentage.eng(w:2)";
            format_alt = " $icon $available.eng(w:2) / $total.eng(w:2)";
          }
          {
            block = "sound";
            format = " $icon {$volume.eng(w:2)|}";
            click = [{
              button = "left";
              cmd = "pavucontrol";
            }];
          }
	] ++ lib.optionals has_battery [
          {
            block = "battery";
            device = "BAT0";
            format = " $icon $percentage {$time_remaining.dur(hms:true, min_unit:m)|}";
            full_format = " $icon $percentage ";
            charging_format = " $icon $percentage ";
            info = 60;
            good = 60;
            warning = 30;
            critical = 15;
          }
	  ] ++
        [
          {
            block = "net";
            format = " $icon ";
            click = [{
              button = "left";
              cmd = "kitty nmtui";
            }];
          }
          {
            block = "bluetooth";
            mac = "D7:91:0E:87:EE:00";
            format = " $icon";
            disconnected_format = " $icon";
            click = [{
              button = "left";
              cmd = "blueman-manager";
            }];
          }
          {
            block = "keyboard_layout";
            driver = "sway";
            sway_kb_identifier = sway_kb_identifier;
            format = " $layout";
            interval = 1;
            mappings = {
              "English (US)" = "EN";
              "Macedonian (N/A)" = "MK";
            };
            click = [
              {
                button = "left";
                cmd = "swaymsg input type:keyboard xkb_switch_layout next";
              }
            ];
          }
          {
            block = "time";
            interval = 5;
            format = " $timestamp.datetime(f:'%a %b %d %k:%M') ";
          }
        ];
        settings = {
          icons = {
            icons = "material-nf";
            overrides = {
              net_wired= [ "" ];
              cpu = [ "" ];
              memory_mem = [ "" ];
              mouse = [ "󰂯" ];
              bluetooth = [ "󰂯" ];
            };
          };
        };
      };
    };
  };

  programs.rofi = {
    enable = true;
  };

  programs.keepassxc = {
    enable = true;
    settings = {
      General = {
        ConfigVersion = 2;
        MinimizeAfterUnlock = true;
      };
      Browser = {
        Enabled = true;
        UpdateBinaryPath = false;
      };
      GUI = {
        ShowTrayIcon = true;
        MinimizeToTray = true;
        MinimizeOnStartup = true;
        TrayIconAppearance = "monochrome-light";
      };
      KeeShare.QuietSuccess = true;
      Security = {
        LockDatabaseIdle = false;
        LockDatabaseScreenLock = false;
      };
    };
  };

  programs.chromium = {
    enable = true;
    commandLineArgs = [
      # dark Chrome UI + prefers-color-scheme: dark
      "--force-dark-mode"
      "--enable-features=WebUIDarkMode"
    ];
    extensions = [
      "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
    ];
  };

  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";

    profiles.default = {
      extensions.packages =
        with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
          keepassxc-browser
          sponsorblock
        ];
      settings = {
        "browser.ml.enable" = false;
        "browser.ml.chat.enabled" = false;
        "browser.ml.chat.menu" = false;
        "browser.ml.chat.page" = false;
        "browser.ml.chat.page.footerBadge" = false;
        "browser.ml.chat.page.menuBadge" = false;
        "browser.ml.linkPreview.enabled" = false;
        "browser.ml.pageAssist.enabled" = false;
        "extensions.ml.enabled" = false;
        "browser.search.visualSearch.featureGate" = false;

        "browser.shell.checkDefaultBrowser" = false;
        "browser.sessionstore.resume_from_crash" = false;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
        "layout.css.prefers-color-scheme.content-override" = 0;

        "extensions.autoDisableScopes" = 0;
      };
    };
  };

  programs.vscodium = {
    enable = true;
    package = unstable-pkgs.vscodium;
    profiles.default = {
      userSettings = {
        "terminal.integrated.profiles.linux" = {
          "fish" = {
            "path" = "${pkgs.fish}/bin/fish";
          };
        };
        "terminal.integrated.defaultProfile.linux" = "fish";
      };
      extensions = with unstable-pkgs.vscode-extensions; [
        vscodevim.vim
        mkhl.direnv
        oxc.oxc-vscode
        gruntfuggly.todo-tree
        vadimcn.vscode-lldb
      ];
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      global.hide_env_diff = true;
    };
  };
}
