{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unzip
    zip
    curl
    file
    lsof
    rsync
    gnumake
    gcc
    cmake
    pkg-config
    autoconf
    automake
    bison
    re2c
    gettext
    rlwrap
    dos2unix
    sox
    yt-dlp
    jdk17
    php
    dotnet-sdk
    clojure
    leiningen
    k9s
    gh-dash
    railway
    docker-compose
  ];

  home.homeDirectory = "/home/kremeshnoi";

  home.sessionVariables.SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/ssh-agent.socket";

  dotfiles.herdrKeys = ../../../shared/herdr/keys-windows.toml;
  home.file.".local/bin/herdr-nav".source = ./herdr-nav;

  xdg.configFile."lazygit/config.yml".source = ../../../shared/lazygit/config.yml;
  xdg.configFile."lazydocker/config.yml".source = ../../../shared/lazydocker/config.yml;
}
