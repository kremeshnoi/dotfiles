{ lib, pkgs, ... }:

let
  languageServers = with pkgs; [
    typescript-language-server
    vue-language-server
    vscode-langservers-extracted
    kotlin-language-server
    jdt-language-server
    lua-language-server
    clojure-lsp
    bash-language-server
    nil
    taplo
    dockerfile-language-server
    docker-compose-language-service
    rust-analyzer-unwrapped
    ruby-lsp
    intelephense
    prettier
  ];

  helix = pkgs.runCommand "helix-${pkgs.helix.version}" {
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    meta.mainProgram = "hx";
  } ''
    mkdir -p $out
    cp -rL ${pkgs.helix}/share $out/share
    makeBinaryWrapper ${pkgs.helix}/bin/hx $out/bin/hx --prefix PATH : ${lib.makeBinPath languageServers}
  '';
in
{
  programs.helix = {
    enable = true;
    package = helix;
  };

  xdg.configFile."helix".source = ../shared/helix;
}
