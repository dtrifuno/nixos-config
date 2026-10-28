{ config, pkgs, ... }:

{
  services.displayManager.gdm.enable = true;

  # for SVG icon support in swaybar
  programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    waylock.enableGnomeKeyring = true;
    gdm.enableGnomeKeyring = true;
  };

  environment.systemPackages = with pkgs; [
    rofi
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;

    wlr.settings = {
      screencast = {
        max_fps = 60;
        chooser_type = "dmenu";
        chooser_cmd = "${pkgs.rofi}/bin/rofi -dmenu";
      };
    };

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    config.sway = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = "wlr";
      "org.freedesktop.impl.portal.Screenshot" = "wlr";
    };
  };
}
