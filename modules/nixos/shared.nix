{ config, pkgs, lib, ... }:

{
  users.groups.media = {};
  users.groups.nixos-config = {};
  users.groups.password-db = {};

  systemd.tmpfiles.rules = [
    "d /srv/music 2775 root media - -"
    "d /srv/nixos-config 2775 root nixos-config - -"
    "d /srv/password-db 2775 root password-db - -"
  ];
}
