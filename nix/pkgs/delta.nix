{ stdenvNoCC, fetchurl }:

let
  version = "0.20.1";
  assets = {
    x86_64-linux = {
      name = "delta-${version}-x86_64-unknown-linux-musl";
      hash = "sha256-ady0BD9VwpEY9AjG79MBFeCk4KZwklM0O4yPqBSrSjE=";
    };
    aarch64-darwin = {
      name = "delta-${version}-aarch64-apple-darwin";
      hash = "sha256-vBg5zqaSiNRnOiT6/7uCXUCMqQfg99M7FnjJ5s3V5Y4=";
    };
  };
  asset = assets.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation {
  pname = "delta";
  inherit version;
  src = fetchurl {
    url = "https://github.com/dandavison/delta/releases/download/${version}/${asset.name}.tar.gz";
    inherit (asset) hash;
  };
  installPhase = "install -Dm755 delta $out/bin/delta";
  meta.mainProgram = "delta";
}
