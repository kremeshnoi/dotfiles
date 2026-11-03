{ lib, ... }:

let
  accent = "fg=#FFBAF3";
  ohmyzsh = ../shared/zsh/ohmyzsh;
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    history = {
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
        command = accent;
        builtin = accent;
        function = accent;
        alias = accent;
        suffix-alias = accent;
        global-alias = accent;
        hashed-command = accent;
        autodirectory = accent;
        reserved-word = accent;
        precommand = accent;
        path = "none";
        path_pathseparator = "none";
        path_prefix = "none";
        path_prefix_pathseparator = "none";
      };
    };

    shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      v = "nvim";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      c = "claude --dangerously-skip-permissions";
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 510 ''
        command -v rbenv >/dev/null && eval "$(rbenv init - zsh)"
        command -v fnm >/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"

        [ -r "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

        if [[ -o interactive && -z "$HERDR_ENV" && -z "$NO_HERDR" && -z "$SSH_CONNECTION" && "$TERM_PROGRAM" != "vscode" ]] && command -v herdr >/dev/null; then
          herdr && exit
        fi
      '')
      ''
        setopt INC_APPEND_HISTORY
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

        source ${ohmyzsh}/lib/git.zsh
        source ${ohmyzsh}/plugins/git/git.plugin.zsh

        typeset -U path PATH

        unalias claude 2>/dev/null
        function claude {
          command claude-trust "$PWD" 2>/dev/null
          command claude "$@"
        }
      ''
    ];
  };
}
