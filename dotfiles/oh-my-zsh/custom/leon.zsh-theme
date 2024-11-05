ZSH_THEME_GIT_PROMPT_PREFIX="("

# source $ZSH/custom/zsh-git-prompt/zshrc.sh

hostname_color() {
    case `hostname` in
        "tpad" )
            # 002 == green
            echo -n "002";;
        "flip" )
            # 013 == pink
            echo -n '013';;
        * )
            host_random_color.py;;
    esac
}

maybe_git_super_status() {
    if [ -z ${NO_GIT_PROMPT+x} ]; then
        echo -n $(_zsh_git_prompt_git_status)
    fi
}

ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}+"

HOST_COLOR=$(hostname_color)
PROMPT='[%T]-%{$fg[yellow]%}%n%{$reset_color%}@%{$FG['
PROMPT+=$HOST_COLOR
PROMPT+=']%}%m%{$reset_color%}:%{$fg[cyan]%}%3~%{$reset_color%}$(maybe_git_super_status) %# '
RPROMPT='[%(?.%{$fg[green]%}.%{$fg[red]%})%?%{$reset_color%}]'
