# Found on the ZshWiki
#  http://zshwiki.org/home/config/prompt
#

source $ZSH/custom/zsh-git-prompt/zshrc.sh

ZSH_THEME_GIT_PROMPT_PREFIX="("

function git_status_disable_on_remote {
    df -l . &> /dev/null
    if [ "$?" -eq "0" ]; then
        echo $(git_super_status)
    fi
}

PROMPT="[%T]-%{$fg[yellow]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:%{$fg[cyan]%}%3~ %{$reset_color%}$(git_status_disable_on_remote) %% "
RPROMPT="[%(?.%{$fg[green]%}.%{$fg[red]%})%?%{$reset_color%}]"