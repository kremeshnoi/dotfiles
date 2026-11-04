{ config, lib, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dev/dotfiles";

  kotlin-lsp = pkgs.stdenv.mkDerivation rec {
    pname = "kotlin-lsp";
    version = "263.7084.0";
    src = pkgs.fetchurl {
      url = "https://download.jetbrains.com/language-server/kotlin-server/${version}/kotlin-server-${version}.tar.gz";
      sha256 = "ae0c4b01e17ab73a4a5227a78ea99e6dcbe3e499600315b22759a4e4cddd11df";
    };
    nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper ];
    buildInputs = with pkgs; [ stdenv.cc.cc.lib zlib freetype fontconfig alsa-lib wayland libxkbcommon xorg.libX11 xorg.libXext xorg.libXi xorg.libXrender xorg.libXtst ];
    autoPatchelfIgnoreMissingDeps = true;
    dontStrip = true;
    installPhase = ''
      mkdir -p $out/share/kotlin-lsp $out/bin
      cp -r . $out/share/kotlin-lsp
      makeWrapper $out/share/kotlin-lsp/bin/intellij-server $out/bin/kotlin-lsp
    '';
  };

  twiggy-language-server = pkgs.writeShellScriptBin "twiggy-language-server" ''
    exec ${pkgs.twig-language-server}/bin/twig-language-server "$@"
  '';

  languageServers = with pkgs; [
    typescript-language-server
    vue-language-server
    vscode-langservers-extracted
    tailwindcss-language-server
    yaml-language-server
    twiggy-language-server
    kotlin-lsp
    jdt-language-server
    lua-language-server
    clojure-lsp
    bash-language-server
    nil
    ty
    ruff
    marksman
    taplo
    dockerfile-language-server
    docker-compose-language-service
    lemminx
    sqls
    ts_query_ls
    rust-analyzer-unwrapped
  ];

  helix = pkgs.symlinkJoin {
    name = "helix-${pkgs.helix.version}";
    paths = [ pkgs.helix ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/hx --prefix PATH : ${lib.makeBinPath languageServers}
    '';
    meta.mainProgram = "hx";
  };
in
{
  programs.helix = {
    enable = true;
    package = helix;
  };

  xdg.configFile."helix".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/shared/helix";
}
