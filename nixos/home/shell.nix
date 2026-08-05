{ config, pkgs, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    LESS = "-R -F -X -i";
    LESSOPEN = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.local/bin"
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    history = {
      path = "${config.home.homeDirectory}/.zsh_history";
      size = 10000;
      save = 10000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
    };

    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };

    syntaxHighlighting = {
      enable = true;
      styles = {
        command = "fg=#FFBAF3";
        builtin = "fg=#FFBAF3";
        function = "fg=#FFBAF3";
        alias = "fg=#FFBAF3";
        suffix-alias = "fg=#FFBAF3";
        global-alias = "fg=#FFBAF3";
        hashed-command = "fg=#FFBAF3";
        autodirectory = "fg=#FFBAF3";
        reserved-word = "fg=#FFBAF3";
        precommand = "fg=#FFBAF3";
        path = "none";
        path_pathseparator = "none";
        path_prefix = "none";
        path_prefix_pathseparator = "none";
      };
    };

    shellAliases = {
      vi = "nvim";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      c = "claude --dangerously-skip-permissions";
      rebuild = "sudo nixos-rebuild switch --flake ~/dev/nixos-config#alex-nixos";
    };

    initContent = ''
      unsetopt BEEP LIST_BEEP HIST_BEEP

      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}" 'ma=27;01'

      autoload -Uz vcs_info
      precmd() { vcs_info }
      zstyle ':vcs_info:git:*' formats ' (%b)'
      zstyle ':vcs_info:*' enable git
      setopt PROMPT_SUBST
      PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%F{#FFBAF3}''${vcs_info_msg_0_}%f$ '
    '';
  };

  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden --glob '!.git/*'";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--info=inline"
    ];
    fileWidgetCommand = "rg --files --hidden --glob '!.git/*'";
    fileWidgetOptions = [
      "--preview 'head -200 {}'"
      "--preview-window right:60%:wrap"
    ];
    changeDirWidgetCommand = "fd --type d --hidden --exclude .git";
    changeDirWidgetOptions = [
      "--preview 'ls -A --color=always {}'"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
