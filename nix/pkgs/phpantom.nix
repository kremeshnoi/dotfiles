{ lib, stdenvNoCC, fetchurl, autoPatchelfHook, stdenv }:

let
  version = "0.11.1";
  assets = {
    x86_64-linux = {
      name = "phpantom_lsp-x86_64-unknown-linux-gnu.tar.gz";
      hash = "sha256-kG3YEE1L+CqhxCJfuil6kP8c/wVS32Ne6Fj8Jy9EX8Y=";
    };
    aarch64-darwin = {
      name = "phpantom_lsp-aarch64-apple-darwin.tar.gz";
      hash = "sha256-ujKkBnf+L6h/RPP3zm3aZ4pVp3DQbXfy/hKNzHQuF8Y=";
    };
  };
  asset = assets.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation {
  pname = "phpantom-lsp";
  inherit version;
  src = fetchurl {
    url = "https://github.com/PHPantom-dev/phpantom_lsp/releases/download/${version}/${asset.name}";
    inherit (asset) hash;
  };
  sourceRoot = ".";
  nativeBuildInputs = lib.optional stdenvNoCC.hostPlatform.isLinux autoPatchelfHook;
  buildInputs = lib.optional stdenvNoCC.hostPlatform.isLinux stdenv.cc.cc.lib;
  installPhase = "install -Dm755 phpantom_lsp $out/bin/phpantom_lsp";
  meta.mainProgram = "phpantom_lsp";
}
