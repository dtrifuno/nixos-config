{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    reaper
    audacity
    musescore
    surge-xt
    zynaddsubfx
    dexed
  ];
}
