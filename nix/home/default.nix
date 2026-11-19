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
