{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "aseprite"
      "corefonts"
      "vista-fonts"
      "claude-code"
      "vscode-extension-anthropic-claude-code"
      "reaper"
    ];
}
