{ config, lib, pkgs, ... }:

let
  herdr = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "herdr";
    version = "0.9.5";
    src = pkgs.fetchurl {
      url = "https://github.com/herdrdev/herdr/releases/download/v${version}/herdr-linux-x86_64";
      sha256 = "14d9e8bc8b4a9e0118d77c32266f76d461f09b40342eb23752960bd89f59929d";
    };
    dontUnpack = true;
    installPhase = "install -Dm755 $src $out/bin/herdr";
  };
  fhsWrappers = pkgs.runCommand "fhs-wrappers" { nativeBuildInputs = [ pkgs.makeBinaryWrapper ]; } ''
    mkdir -p $out/bin
    for f in ${config.system.path}/bin/*; do
      makeBinaryWrapper "$f" "$out/bin/$(basename "$f")"
    done
    makeBinaryWrapper ${pkgs.bashInteractive}/bin/bash $out/bash
    makeBinaryWrapper ${herdr}/bin/herdr $out/herdr
  '';
in
{
  imports = [
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "kremeshnoi";
  wsl.useWindowsDriver = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Riga";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.kremeshnoi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    linger = true;
  };

  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      zstd
      openssl
      curl
      libxml2
      libffi
      glib
      icu
      libuuid
      libGL
      expat
      xz
      bzip2
      ncurses
      sqlite
      util-linux
      gmp
      libyaml
      readline
      gdbm
      libxcrypt-legacy
    ];
  };

  system.activationScripts.fhsWrappers.text = ''
    rm -rf /usr/local/bin
    mkdir -p /usr/local/bin /home/linuxbrew/.linuxbrew/bin
    cp ${fhsWrappers}/bin/* /usr/local/bin/
    cp -f ${fhsWrappers}/herdr /home/linuxbrew/.linuxbrew/bin/herdr
    cp -f ${fhsWrappers}/bash /bin/bash.tmp && mv -f /bin/bash.tmp /bin/bash
  '';

  systemd.user.services.ssh-agent = {
    description = "SSH authentication agent";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
      ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
    };
  };

  systemd.user.services.herdr-navd = {
    description = "herdr navigation socket for AutoHotkey";
    wantedBy = [ "default.target" ];
    unitConfig.ConditionUser = "kremeshnoi";
    serviceConfig = {
      ExecStart = "${pkgs.python3}/bin/python3 %h/.local/bin/herdr-nav serve";
      Restart = "always";
      RestartSec = 1;
    };
  };

  hardware.graphics.enable = true;

  environment.sessionVariables.LD_LIBRARY_PATH = [ "/usr/lib/wsl/lib" ];

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    herdr
    git
    git-lfs
    gh
    neovim
    ripgrep
    fd
    fzf
    zoxide
    tree
    unzip
    zip
    wget
    curl
    file
    lsof
    htop
    jq
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
    sqlite
    rlwrap
    dos2unix
    sox
    yt-dlp
    fastfetch
    ngrok
    jdk17
    php
    python3
    uv
    pnpm
    go
    dotnet-sdk
    clojure
    leiningen
    k9s
    btop
    gh-dash
    stylua
    dprint
    tree-sitter
    shfmt
    eslint_d
    prettier
    railway
    wakatime-cli
    docker-compose
  ];

  system.stateVersion = "26.05";
}
