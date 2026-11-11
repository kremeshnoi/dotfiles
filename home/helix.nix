{ config, lib, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dev/dotfiles/dotfiles";

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
