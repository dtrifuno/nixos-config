{ pkgs }:

# Builds an Obsidian community plugin from its GitHub release assets.
{ repo, version, hashes }:

pkgs.linkFarm "obsidian-plugin-${baseNameOf repo}-${version}" (
  builtins.mapAttrs (name: hash: pkgs.fetchurl {
    url = "https://github.com/${repo}/releases/download/${version}/${name}";
    inherit hash;
  }) hashes
)
