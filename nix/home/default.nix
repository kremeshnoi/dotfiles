{ pkgs, ... }:

let
  lazygit = pkgs.callPackage ../pkgs/lazygit.nix { };
  delta = pkgs.callPackage ../pkgs/delta.nix { };
in

{
  imports = [
    ./zsh.nix
    ./helix.nix
    ./herdr.nix
    ./claude.nix
    ./git.nix
    ./bat.nix
    ./ssh.nix
    ./copy-files.nix
  ];

  home.username = "kremeshnoi";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    lazydocker
    lazygit
    sqlit-tui
    delta
    bat
    fnm
    git
    gh
    tree
    wget
    jq
    btop
    nvd
    nix-tree
    python3
    uv
    go
    stylua
    dprint
    shfmt
    eslint_d
    prettier
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.zoxide.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
