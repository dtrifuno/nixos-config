{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "corefonts"
      "vista-fonts"
      "claude-code"
      "vscode-extension-anthropic-claude-code"
      "reaper"
    ];
}
