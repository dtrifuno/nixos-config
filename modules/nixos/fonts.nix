{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    open-sans
    noto-fonts
    noto-fonts-color-emoji
    inter
    roboto
    rubik
    fira
    corefonts
    vista-fonts
    nerd-fonts.fira-code
    nerd-fonts.ubuntu-mono
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.inconsolata
    nerd-fonts.jetbrains-mono
  ];
}
