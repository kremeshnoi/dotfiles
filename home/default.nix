{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dev/dotfiles";
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [
    ./zsh.nix
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
    defaultCommand = "rg --files --hidden --glob '!.git/*'";
    defaultOptions = [ "--height 40%" "--layout=reverse" "--border" "--info=inline" ];
    fileWidgetCommand = "rg --files --hidden --glob '!.git/*'";
    fileWidgetOptions = [ "--preview 'head -200 {}'" "--preview-window right:60%:wrap" ];
    changeDirWidgetCommand = "fd --type d --hidden --exclude .git";
    changeDirWidgetOptions = [ "--preview 'ls -A --color=always {}'" ];
  };

  programs.zoxide.enable = true;
  programs.dircolors.enable = true;

  xdg.configFile."herdr/config.toml".source = link "${dotfiles}/windows/herdr/config.toml";
  home.file.".local/bin/herdr-nav".source = link "${dotfiles}/windows/herdr/herdr-nav";
}
