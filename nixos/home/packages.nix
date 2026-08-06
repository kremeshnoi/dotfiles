{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dive
    glow
    herdr
    k9s
    gh
    neovim

    eslint_d
    prettier
    shfmt
    tree-sitter
  ];
}
