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
    ./secrets.nix
    ./copy-files.nix
    ./darwin.nix
  ];

  home.username = "kremeshnoi";
  home.homeDirectory = if isDarwin then "/Users/kremeshnoi" else "/home/kremeshnoi";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    lazydocker
    sops
    age
  ];

  home.sessionVariables = lib.optionalAttrs (!isDarwin) {
    SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/ssh-agent.socket";
  };

  programs.neovim = {
    enable = true;
    sideloadInitLua = true;
    withPython3 = true;
    withRuby = true;
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
  programs.dircolors.enable = true;
}
