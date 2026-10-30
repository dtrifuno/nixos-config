{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    aseprite
    blender
    blockbench
    gimp
    godot-mono
    inkscape
  ];
}
