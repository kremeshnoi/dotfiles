{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bandwhich
    btop
    dive
    dua
    fastfetch
    glow
    herdr
    k9s
    lazydocker
    rainfrog
    superfile
    watchexec
    xh

    bat
    eza
    fd
    ripgrep
    jq
    tree
    dos2unix
    unzip
    zip
    wget
    curl
    sqlite
    yt-dlp

    gh
    git-lfs
    lazygit
    neovim

    ngrok
    railway
    uv

    cargo-llvm-cov
    cargo-watch
    dprint
    eslint_d
    prettier
    shfmt
    tree-sitter
  ];
}
