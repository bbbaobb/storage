if [ -x "$(command -v xray)" ];then
    export all_proxy=http://127.0.0.1:10809
fi

#{{{zgen init
if [ ! -d $HOME/.zgen ]; then
    git clone --depth 1 https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
    curl https://raw.githubusercontent.com/skywind3000/z.lua/master/z.lua -o $HOME/.zgen/z.lua
fi

if [ -x "$(command -v lua)"  ]; then
    eval "$(lua $HOME/.zgen/z.lua --init zsh enhanced once echo)"
fi

source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then
    echo "Creating a zgen save"
    #zgen oh-my-zsh
    # plugins
    #zgen load robbyrussell/oh-my-zsh plugins/colored-man-pages
    #zgen load chrissicool/zsh-256color
    #zgen load zsh-users/zsh-history-substring-search
    #zgen load zsh-users/zsh-completions src
    zgen load zsh-users/zsh-completions src
    #zgen load rupa/z
    zgen load zsh-users/zsh-autosuggestions
    zgen load zsh-users/zsh-history-substring-search
    #zgen load zdharma/history-search-multi-word
    zgen load zdharma-continuum/history-search-multi-word
    zgen load zdharma-continuum/fast-syntax-highlighting

    #zgen load zdharma/fast-syntax-highlighting
    #zgen load zsh-users/zsh-completions

    # save all to init script
    zgen save
fi

ZSH_AUTOSUGGEST_USE_ASYNC=1
#ZSH_AUTOSUGGEST_STRATEGY=(history completion)
#ZSH_AUTOSUGGEST_COMPLETION_IGNORE
ZSH_AUTOSUGGEST_HISTORY_IGNORE="(rm *|which *|ins *|purge *|vi *|f *|file *)"
#}}}

#{{{ keybind

#bindkey -v
bindkey -e

bindkey '^ ' autosuggest-accept

#bindkey -M emacs '^P' history-substring-search-up
#bindkey -M vicmd 'j' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_FUZZY=1
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# substitute built-in ctrl-u
bindkey '^u'      backward-kill-line


# sudo plugin
function sudo-command-line() {
    [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER" || {
        zle beginning-of-line
        zle delete-word
        zle delete-char
    }
    zle end-of-line
}
zle -N sudo-command-line
bindkey '\e\e' sudo-command-line
#bindkey '^r' sudo-command-line
#bindkey '^f' sudo-command-line

function make_man() {
    BUFFER="man $BUFFER"
    zle end-of-line
}
zle -N make_man
bindkey '^[m' make_man

function substitute_head() {
    if [[ $BUFFER == sudo\ * ]]; then
        zle beginning-of-line
        zle delete-word
        zle delete-word
        BUFFER="sudo $BUFFER"
        zle forward-word
        zle backward-char
    else
        zle beginning-of-line
        zle delete-word
    fi
}
zle -N substitute_head
bindkey '^[a' substitute_head

# https://gist.github.com/mooz/4175464
function tmux-attach() {
    # Launching tmux inside a zle widget is not easy
    # Hence, We delegate the work to the parent zsh
    BUFFER=" { tmux list-sessions >& /dev/null && tmux attach 2>/dev/null } || tmux"
    zle accept-line
}
zle -N tmux-attach
# Define a shortcut key for launching tmux (Ctrl+t)
bindkey '^G' tmux-attach

#}}}

setopt autocd
setopt interactivecomments

#{{{?????????

#{{{ ????????????
# /v/c/p/p => /var/cache/pacman/pkg
setopt complete_in_word

#????????????????????????????????????
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

setopt AUTO_LIST
setopt AUTO_MENU
# ???????????????????????????????????????????????????
# setopt MENU_COMPLETE
#

autoload -Uz compinit && compinit

function _force_rehash() {
    ((CURRENT == 1)) && rehash
    return 1    # Because we didn't really complete anything
}
zstyle ':completion:::::' completer _force_rehash _complete _approximate


# ??????????????????
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always
zstyle ':completion:*' select-prompt '%SSelect:  lines: %L  matches: %M  [%p]'
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

# ????????????
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'
zstyle ':completion::complete:*' '\\'

# ??????????????????
export ZLSCOLORS=$LS_COLORS
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# ???????????????
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

# ????????????
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# ????????????????????????
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'

# kill ??????
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'

# cd ~ ????????????
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'

zstyle ':completion:*' list-prompt   ''
zstyle ':completion:*' select-prompt ''


zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _files _ignored
setopt nocorrect

##}}}

#{{{ ??????

# ????????????
autoload -U zmv

# ????????????????????????
compdef cwi=time
compdef vwi=time
compdef fwi=time
compdef lwi=time
compdef st=sudo
#compdef whoneeds=pactree

zstyle ':completion:*:ping:*' hosts baidu.com google.com barackmarx.ml
zstyle ':completion:*:my-accounts' users-hosts user@{host1,host2}
#}}}

#}}}?????????

unsetopt correct_all
unsetopt correct
DISABLE_CORRECTION="true"

#{{{ ??? zsh ???????????????
#export LC_ALL=en_US.UTF-8
export LANG=C.UTF-8
export PYTHONDONTWRITEBYTECODE=1
(($+USER)) || export USER=username
(($+SHELL)) || export SHELL=/bin/zsh
umask 022



#path+=(~/.bin)
# ????????? exec zsh ??? ctrl + a ??????
export EDITOR=vim
export PAGER='less -irf'
export GREP_COLOR='40;33;01'
# ?????? ctrl + s
stty -ixon

# man ??????
export LESS_TERMCAP_mb=$'\E[01;31m'
# ?????????????????????
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
# ????????????
export LESS_TERMCAP_us=$'\E[04;36;4m'

# funcend

#}}}

#export PATH=$HOME/.cargo/bin:$HOME/.local/bin:$PATH
export PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/usr/sbin
export CARGO_NET_GIT_FETCH_WITH_CLI=true
export MOZ_ENABLE_WAYLAND=1
#export manpath=$manpath

export TERM=xterm-256color
#[[ -z $TMUX ]] && (tmux attach 2>/dev/null || tmux)


#unsetopt aliases
alias gfw="http_proxy=http://127.0.0.1:10808 https_proxy=http://127.0.0.1:10808 all_proxy=http://127.0.0.1:10808 "
# {{{ alias
#alias sudo="sudo "
alias purge="sudo apt purge --auto-remove "

alias l='ls -F --color=auto'
alias ll="ls -l --color=auto"
alias la='ls -a --color=auto'
alias lla='ls -alF --color=auto'
alias ls='ls -F --color=auto'
alias ld='ls -d'

alias cls="clear "

alias which='command -v '
alias f='file '
#alias ls='ls -F --color'
alias del='command trash-put '

#alias diff='colordiff '

function rmssh(){
    ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$1"
}

function sys() {
    sudo systemctl status --no-pager --full $1
}
function resys() {
    sudo systemctl restart $1 && sudo systemctl status --no-pager --full $1
}
compdef _functions sys
compdef _functions resys

#alias resys="sudo systemctl restart "
#alias sys="sudo systemctl status --no-pager --full "


function tree() {
    tree $1 |less
}

alias quit='gnome-session-quit'

alias pkglist='dpkg -l|grep --color=auto -i'
ins() {
    dpkg-query -W --showformat='${binary:Package}\n'|grep -i "$1"
}
inq() {
    dpkg -l|grep -i $1
}
alias grep='grep --color=auto '

function cl() {
    emulate -L zsh
    cd $1 && ls -F --color=auto
}

# }}}

# ?????????????????????????????? cd ~xxx
hash -d log=/var/log
hash -d deb=/var/cache/apt/archives
hash -d linux=/lib/modules/$(command uname -r)/
##d# start
#hash -d doc=/usr/share/doc
#hash -d slog=/var/log/syslog
#hash -d src=/usr/src
#hash -d www=/var/www
##d# end

alias app='adb shell pm list packages|grep '
alias b='bash -c '
#alias tarbackup='tar -pcvzf /backup.tgz  /  --exclude=/backup.tgz --exclude=/lost+found --exclude=/proc/* --exclude=/sys/* --exclude=/tmp/* --exclude=/dev/* --exclude=/media/* --exclude=/mnt/* '

#{{{ ???????????????????????????
# ????????????????????????
export HISTSIZE=10000000
# ??????????????????????????????????????????
export SAVEHIST=10000000
# ??????????????????
export HISTFILE=~/.zhistory
# ?????? esc ??????????????? 0.01s
export KEYTIMEOUT=1
# ?????? zsh ?????????????????????
setopt SHARE_HISTORY
# ??????????????????????????????????????????????????????????????????
#setopt HIST_IGNORE_DUPS
# remove older duplicate history entry
setopt HIST_IGNORE_ALL_DUPS
# ??????????????????????????????????????????
#setopt EXTENDED_HISTORY
# ?????? cd ????????????????????????cd -[TAB]??????????????????
setopt AUTO_PUSHD
# ????????????????????????????????????
setopt PUSHD_IGNORE_DUPS
# ??????????????????????????????????????????????????????????????????
setopt HIST_IGNORE_SPACE
# ??????????????????
setopt GLOB_DOTS
setopt EXTENDED_GLOB
# ??????????????????????????????????????????
setopt NO_BG_NICE
# ??????????????????
unsetopt BEEP
#}}}

#{{{ PROMPT

_fish_collapsed_pwd() {
  local i pwd
  pwd=("${(s:/:)PWD/#$HOME/~}")
  if (( $#pwd > 1 )); then
    for i in {1..$(($#pwd-1))}; do
      if [[ "$pwd[$i]" = .* ]]; then
        pwd[$i]="${${pwd[$i]}[1,2]}"
      else
        pwd[$i]="${${pwd[$i]}[1]}"
      fi
    done
  fi
  echo "${(j:/:)pwd}"
}

setopt PROMPT_SUBST
autoload -U colors && colors
#export PROMPT='%f%n@%m %F{2}$(_fish_collapsed_pwd)%f> '
#export PROMPT='%B%(?:%F{yellow}%n:%F{red}%n)%f@%F{blue}%m%b %F{green}$(_fish_collapsed_pwd)%f> '
#export PROMPT='%B%F{red}%n%f@%F{red}%m%b %F{green}$(_fish_collapsed_pwd)%f> '
export PROMPT='%B%F{green}%n%f@%F{red}%m%b %F{green}$(_fish_collapsed_pwd)%f> '
#export PROMPT='%F{green}%n%f@%F{red}%m %F{green}$(_fish_collapsed_pwd)%f> '
#export PROMPT='%B%F{yellow}%n%F{green}@%F{blue}%m%b %F{green}$(_fish_collapsed_pwd)%f> '
#export PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

#}}}
