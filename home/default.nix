{ pkgs, ... }:

{
  imports = [
    ./zsh.nix
    ./helix.nix
    ./herdr.nix
    ./claude.nix
    ./git.nix
    ./ssh.nix
    ./secrets.nix
  ];

  home.username = "kremeshnoi";
  home.homeDirectory = "/home/kremeshnoi";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    lazydocker
    sops
    age
  ];

  home.sessionVariables = {
    VISUAL = "nvim";
    LESS = "-R -F -X -i";
    SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/ssh-agent.socket";
    RBENV_ROOT = "$HOME/.rbenv";
    DENO_INSTALL = "$HOME/.deno";
    FNM_PATH = "$HOME/.local/share/fnm";
  };

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/.rbenv/bin"
    "$HOME/.deno/bin"
    "$HOME/.local/share/fnm"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    sideloadInitLua = true;
    withPython3 = true;
    withRuby = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
    defaultCommand = "rg --files --hidden --glob '!.git/*'";
    defaultOptions = [ "--height 40%" "--layout=reverse" "--border" "--info=inline" ];
  };

  programs.zoxide.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.dircolors.enable = true;
}
