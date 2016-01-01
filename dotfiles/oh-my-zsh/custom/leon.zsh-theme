# Found on the ZshWiki
#  http://zshwiki.org/home/config/prompt
#


ZSH_THEME_GIT_PROMPT_PREFIX="("

source $ZSH/custom/zsh-git-prompt/zshrc.sh

git_status_disable_on_remote() {
    df -l . &> /dev/null
    if [ "$?" -eq "0" ]; then
        echo $(git_super_status)
    fi
}

hostname_color() {
    case "$HOST" in
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

HOST_COLOR=$(hostname_color)
PROMPT='[%T]-%{$fg[yellow]%}%n%{$reset_color%}@%{$FG['
PROMPT+=$HOST_COLOR
PROMPT+=']%}%m%{$reset_color%}:%{$fg[cyan]%}%3~%{$reset_color%}$(git_status_disable_on_remote) %# '
RPROMPT='[%(?.%{$fg[green]%}.%{$fg[red]%})%?%{$reset_color%}]'