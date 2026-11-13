{ stdenvNoCC, fetchurl }:

let
  version = (builtins.fromTOML (builtins.readFile ../../shared/herdr/versions.toml)).herdr;
  assets = {
    x86_64-linux = {
      name = "herdr-linux-x86_64";
      hash = "sha256-FNnovItKngEY13wyJm921GHwm0A0LrI3UpYL2J9Zkp0=";
    };
    aarch64-darwin = {
      name = "herdr-macos-aarch64";
      hash = "sha256-+3fCIyoFqANUITgsiUOS9BdOTjihjkivPdApAVfDp+I=";
    };
  };
  asset = assets.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation {
  pname = "herdr";
  inherit version;
  src = fetchurl {
    url = "https://github.com/herdrdev/herdr/releases/download/v${version}/${asset.name}";
    inherit (asset) hash;
  };
  dontUnpack = true;
  installPhase = "install -Dm755 $src $out/bin/herdr";
}
