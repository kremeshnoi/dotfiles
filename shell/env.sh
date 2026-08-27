export FLYCTL_INSTALL="$HOME/.fly"
export RBENV_ROOT="$HOME/.rbenv"
export DENO_INSTALL="$HOME/.deno"
export FNM_PATH="$HOME/.local/share/fnm"

export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/ssh-agent.socket"

export EDITOR=nvim
export VISUAL=nvim
export LESS='-R -F -X -i'

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fdfind --type d --hidden --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'
export FZF_CTRL_T_OPTS='--preview "head -200 {}" --preview-window right:60%:wrap'
export FZF_ALT_C_OPTS='--preview "ls -A --color=always {}"'

__path_prepend() {
    [ -d "$1" ] || return 0
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}
__path_prepend "$HOME/go/bin"
__path_prepend /usr/local/go/bin
__path_prepend "$FNM_PATH"
__path_prepend "$DENO_INSTALL/bin"
__path_prepend "$RBENV_ROOT/bin"
__path_prepend "$FLYCTL_INSTALL/bin"
__path_prepend "$HOME/.local/bin"
__path_prepend "$HOME/bin"
export PATH
unset -f __path_prepend

if [ -z "$__shell_env_done" ]; then
    [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

    for __brew in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew; do
        [ -x "$__brew" ] && eval "$("$__brew" shellenv)" && break
    done
    unset __brew

    [ -s "$HOME/.config/envman/load.sh" ] && . "$HOME/.config/envman/load.sh"

    if [ -n "$ZSH_VERSION" ]; then
        __cur_shell=zsh
    else
        __cur_shell=bash
    fi
    command -v rbenv >/dev/null && eval "$(rbenv init - $__cur_shell)"
    command -v fnm >/dev/null && eval "$(fnm env --use-on-cd --shell $__cur_shell)"
    unset __cur_shell

    __shell_env_done=1
fi

if [ -d "$HOME/.local/bin/toolchain-shims" ]; then
    PATH="$HOME/.local/bin/toolchain-shims:$PATH"
    export PATH
fi

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if command -v dircolors >/dev/null; then
    if [ -r "$HOME/.dircolors" ]; then
        eval "$(dircolors -b "$HOME/.dircolors")"
    else
        eval "$(dircolors -b)"
    fi
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
elif [ "${OSTYPE#darwin}" != "$OSTYPE" ]; then
    export CLICOLOR=1
    alias grep='grep --color=auto'
fi

command -v nvim >/dev/null && alias vi='nvim'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias c='claude --dangerously-skip-permissions'

__idea='/mnt/c/users/alex/appdata/local/jetbrains/toolbox/apps/IDEA-U/ch-0/231.9011.34/bin/idea64.exe'
[ -x "$__idea" ] && alias idea="$__idea"
unset __idea

if [ -n "$ZSH_VERSION" ]; then
    typeset -U path PATH
else
    __out=
    __ifs=$IFS
    IFS=:
    for __d in $PATH; do
        case ":$__out:" in
            *":$__d:"*) ;;
            *) __out="${__out:+$__out:}$__d" ;;
        esac
    done
    IFS=$__ifs
    PATH=$__out
    export PATH
    unset __out __ifs __d
fi
