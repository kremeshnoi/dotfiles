{ lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in

{
  imports = [
    ./zsh.nix
    ./helix.nix
    ./herdr.nix
    ./claude.nix
    ./git.nix
    ./ssh.nix
    ./copy-files.nix
    ./darwin.nix
  ];

  home.username = "kremeshnoi";
  home.homeDirectory = if isDarwin then "/Users/kremeshnoi" else "/home/kremeshnoi";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    lazydocker
    bat
    fnm
    postgresql
    pspg
  ];

  home.sessionVariables = lib.optionalAttrs (!isDarwin) {
    SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/ssh-agent.socket";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.pgf.enable = true;

  programs.zoxide.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
