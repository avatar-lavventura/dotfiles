#

connect_xhost () {
    timeout 1s xhost + && printf "xhost success" || printf "xhost NOT success"
}

first_login() {
    FILE=$HOME/.zsh_history
    if [ ! -f "$FILE" ]; then
        touch $FILE
    fi

    FILE=$HOME/-i
    if [ ! -f "$FILE" ]; then
        touch $FILE
    fi

    num=$(ps aux | grep -E "[E]macs-x86_64-10_14 --|[e]macs --|[f]irst_login" | wc -l)
    if [ $num -eq 0 ]; then
        echo "## Starting emacs"
        (&>/dev/null emacsclient -t -q &)
    fi

    (&>/dev/null \
       $HOME/venv/bin/python3 -m pip install -qq -U \
       pip setuptools wheel bleach setuptools \
       mypy pip yapf black rope flake8 importmagic autopep8 ccxt &)

    (&>/dev/null \
       /usr/bin/python3 -m pip install -qq -U \
       pip setuptools wheel bleach setuptools \
       mypy pip yapf black rope flake8 importmagic autopep8 ccxt &)

    sudo -E $HOME/personalize/run_start_up.sh
    if [ $(hostname) = "home" ] || [ $(hostname) = "home2" ]; then
        connect_xhost 2>&1 &
        # xterm -e zsh -c "echo $ZSH_VERSION; sleep 1"
    fi
}

preexec() {
    stty sane && stty erase "^H" intr "^C" eof "^D" susp "^Z"
    # echo "$(history 0 | sort -k2 -k1nr | uniq -f1 | sort -n | cut -c8-)" > $HISTFILE
    # stty sane && stty erase "^H" kill "^U" intr "^C" eof "^D" susp "^Z"
    # window_title="\033]0;${PWD##*/}\007"
    # echo -ne "alper $window_title"
}

quote () {
    local quoted=${1//\'/\'\\\'\'};
    printf "\"%s\"" "$quoted"
}

zsh_history_clean () {
    _HISTFILE=~/.zsh_history
    # alias sed="/usr/local/bin/gsed"

    # only word
    # =========
    sed -i -e "
    /:\(.*\);fc[[:blank:]]*$/d
    /:\(.*\);fzf[[:blank:]]*$/d
    /:\(.*\);help[[:blank:]]*$/d
    /:\(.*\);whoami[[:blank:]]*$/d
    /:\(.*\);gll[[:blank:]]*$/d
    /:\(.*\);gl[[:blank:]]*$/d
    /:\(.*\);bb[[:blank:]]*$/d
    /:\(.*\);gp[[:blank:]]*$/d
    /:\(.*\);goo[[:blank:]]*$/d
    /:\(.*\);gaa[[:blank:]]*$/d
    /:\(.*\);.f[[:blank:]]*$/d
    /:\(.*\);.a[[:blank:]]*$/d
    /:\(.*\);.t[[:blank:]]*$/d
    /:\(.*\);sz[[:blank:]]*$/d
    /:\(.*\);cd ..[[:blank:]]*$/d
    /:\(.*\);cd[[:blank:]]*$/d
    /:\(.*\);ls[[:blank:]]*$/d
    /:\(.*\);l[[:blank:]]*$/d
    /:\(.*\);pwd[[:blank:]]*$/d
    /:\(.*\);gs[[:blank:]]*$/d
    /:\(.*\);gd[[:blank:]]*$/d
    /:\(.*\);gdd[[:blank:]]*$/d
    /:\(.*\);ll[[:blank:]]*$/d
    /:\(.*\);eb[[:blank:]]*$/d
    /:\(.*\);gg[[:blank:]]*$/d
    /:\(.*\);r[[:blank:]]*$/d
    /:\(.*\);.e[[:blank:]]*$/d
    /:\(.*\);cd[[:blank:]]*$/d
    /:\(.*\);ls[[:blank:]]*$/d
    /:\(.*\);cd[[:blank:]]*$/d
    /:\(.*\);h[[:blank:]]*$/d

    /ALPER_2TB/d
    /\/pp\//d

    /:\(.*\);rm -rf/d
    /:\(.*\);rm/d
    /:\(.*\);q/d
    /:\(.*\);gc /d
    " $_HISTFILE &>/dev/null


    # # remove lines containing word
    # # ============================
    # sed -i -e '/\/pp\//d' $_HISTFILE

    # # pattern
    # # =======
    # sed -i -e '/:\(.*\);q/d' $_HISTFILE
}

stty eof undef
stty sane && stty erase "^H" intr "^C" eof "^D" susp "^Z" # kill "^U"
stty -ixon

## History file configuration
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000
# [ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
# export PYTHONDONTWRITEBYTECODE="1"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ -s $HOME/.cargo/env ]] && source $HOME/.cargo/env

DISABLE_AUTO_TITLE="true"
## https://stackoverflow.com/a/57415054/2402577
mkdir -p "$HOME/.cache/cpython"
mkdir -p ~/go

ulimit -S -n 10240
export TERM="xterm-256color"
export GPG_TTY=$(tty)
export HOST=`uname -n`
export PYTHONPYCACHEPREFIX="$HOME/.cache/cpython/"
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export PYTHONBREAKPOINT=ipdb.set_trace
export ALTERNATE_EDITOR=""
export BAT_PAGER="less -rR"
export EDITOR="emacsclient -nw"
export CLICOLOR=1
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export HISTCONTROL=ignorespace
export WORKON_HOME="$HOME/venv"
export IGNOREEOF=42
export PROMPT_COMMAND='history -a'

set -o ignoreeof
set ignoreeof=42

autoload -U compinit
compinit

# export FZF_DEFAULT_COMMAND='fd --type file'
# export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
# export FZF_DEFAULT_COMMAND="fd --type file --color=always"
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_DEFAULT_OPTS="--ansi"
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal

export FZF_CTRL_R_OPTS="--bind=ctrl-r:up"
export FZF_DEFAULT_OPTS=" --height 50% --layout=reverse --bind=ctrl-j:accept --bind=ctrl-s:down,ctrl-k:kill-line --bind
change:top --color=16,bg+:#44475a --no-mouse --bind=alt-v:page-up --bind=ctrl-v:page-down"
# --height 40%
# --bind=ctrl-n:ignore --bind=ctrl-p:ignore
export PAGER="less"
export LESS="-iR -j4 --shift 5 -P ?n?f%f .?m(file %i of %m) ..?ltlines %lt-%lb?L/%L. :byte %bB?s/%s. .?e(END) ?x- Next\: %x.:?pB%pB\%..%t"

# https://unix.stackexchange.com/a/150322/198423
# Foreground:  | # Background:
# 30 - black   | # 40 - black
# 31 - red     | # 41 - red
# 32 - green   | # 42 - green
# 33 - yellow  | # 43 - yellow
# 34 - blue    | # 44 - blue
# 35 - magenta | # 45 - magenta
# 36 - cyan    | # 46 - cyan
# 37 - white   | # 47 - white
export LESS_TERMCAP_mb=$'\E[6m'        # begin blinking
export LESS_TERMCAP_md=$'\E[34m'       # begin bold
export LESS_TERMCAP_us=$'\E[4;32m'     # begin underline
export LESS_TERMCAP_me=$'\E[0m'        # end mode
export LESS_TERMCAP_ue=$'\E[0m'        # end underline
export LESS_TERMCAP_se=$'\E[0m'        # end standout-mode
export LESS_TERMCAP_so=$'\E[1;33;33m'  # begin standout-mode - info box
# export LESS_TERMCAP_so=$'\E[30;42m'  # green background, black font


export COLUMNS  # Remember columns for subprocesses for ls
export GPG_TTY=$(tty)
export MANPAGER="less -s -M +Gg"

# export MANPAGER="nvim -u NORC -c 'set ft=man' -"
# https://askubuntu.com/a/1254883/660555
uname_out="$(uname -s)"
case "${uname_out}" in
    Darwin*) # UNIX
        export CLICOLOR=YES
        alias sed="/usr/local/bin/gsed"
        export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
        # always_check
        ;;
    *) # LINUX
        # cat ~/.welcome_home.txt
        # /home/alper/personalize/update_repo.sh y
        if [ $( last -w | sed '/^reboot/,$d' | egrep '^'$(whoami)' +pts/' | wc -l ) -lt 2 ]; then
            if [[ $(hostname) == "home" ]] || [[ $(hostname) == "home2" ]]; then
                num=$(ps aux | grep -E "[g]eth|[e]macs --" | wc -l)
                if [ $num -eq 0 ]; then
                    echo "## First login welcome $(whoami)"
                    first_login
                fi
            fi
        fi
        ;;
esac


# https://gist.github.com/phette23/5270658
# put this in your .bash_profile
if [ $ITERM_SESSION_ID ]; then
    export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND"
fi

[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh

bindkey -r "^O"
bindkey -r "^W"
bindkey -r "^[r"
bindkey -r "\eW"
bindkey -r "\ew"
bindkey -r "^M"
bindkey -r "^D"

bindkey -s "^[n" " _fg\n"  # alt + n
bindkey -s "^[^I" " _fg\n" # alt + tab
bindkey -s "^[r" " run_latest_command\n" # alt + r
# bindkey -s "^Q"  " _fg\n" # ctrl + ]

bindkey "^D"  delete-char
bindkey "^[H" backward-kill-word
bindkey "^M"  accept-line
bindkey '^W'  kill-region
bindkey '\eW' copy-region-as-kill
bindkey '\ew' copy-region-as-kill

zsh_history_clean

# if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
#     tmux -CC new -A -s main
#     # tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
# fi


# bindkey "^O" backward-kill-word

# export PS1='[\u@\h \W]$ ' # Set the command prompt!

# Always list directory contents and set title upon 'cd'
# cd() { builtin cd "$@"; ls -lFah; tabTitle ${PWD##*/}; }

## Install fzf
# git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
# cat .text | toilet -t --gay -f term
# ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'
# export PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# always_check() {
#     num=$(ps aux | grep -E "[E]macs-x86_64-10_14 --|[e]macs --|[f]irst_login" | wc -l)
#     if [ $num -eq 0 ]; then
#         echo "## Starting emacs"
#         (&>/dev/null emacsclient -t -q &)
#     fi
# }
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# (&>/dev/null emacs -nw &)
# (&>/dev/null emacs --daemon &)
# (&>/dev/null emacs --fg-daemon &)
# (emacs --daemon </dev/null >nohup.out 2>nohup.err &) > /dev/null 2>&1
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# function ls {
#   command ls -F -h --color=always -v --author --time-style=long-iso -C "$@" | less -R -X -F
# }

# define commands to copy and paste x clipboard

# ^Xw - copy region, or cut buffer
# ^Xy - paste x clipboard

# in both cases, modifies CUTBUFFER
