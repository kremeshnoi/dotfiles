{ stdenvNoCC, fetchurl }:

let
  version = "0.66.3";
  assets = {
    x86_64-linux = {
      name = "lazygit_${version}_linux_x86_64.tar.gz";
      hash = "sha256-CiP0KalfDQnbKYs8KRU22BjeBmqlqFwlWAbwSQ/2ZWs=";
    };
    aarch64-darwin = {
      name = "lazygit_${version}_darwin_arm64.tar.gz";
      hash = "sha256-aHPmt6U4tSHE1/8/duxJ5tyvpB5gU6aq4zwS9iZj4WM=";
    };
  };
  asset = assets.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation {
  pname = "lazygit";
  inherit version;
  src = fetchurl {
    url = "https://github.com/jesseduffield/lazygit/releases/download/v${version}/${asset.name}";
    inherit (asset) hash;
  };
  sourceRoot = ".";
  installPhase = "install -Dm755 lazygit $out/bin/lazygit";
  meta.mainProgram = "lazygit";
}
