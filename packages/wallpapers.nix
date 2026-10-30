{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "wallpapers";
  version = "1.0";

  src = pkgs.fetchFromGitHub {
    owner = "dtrifuno";
    repo = "wallpapers";
    rev = "286eb971675d00d909184f3784d320c91d999f60";
    hash = "sha256-qX5k1NbPpmwoVqe3IJTM9bVU8E9sSgmjYs1eRX522HE=";
  };

  installPhase = ''
    mkdir -p $out/share/wallpapers
    cp -r . $out/share/wallpapers/
  '';
}
