#

source ~/.unique
export TERM="xterm-256color"
# export TERM="screen-256color"

# export TERM="xterm-256color"
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# --------------------------

export PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@home:\[\033[01;34m\]\w\[\033[00m\]\$ "

# alias e="TERM=xterm-256color emacsclient -t"
# export GOPATH=/usr/local/go/bin/go
# export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"

export MANPATH=/home/netlab/Downloads/camino/man:$MANPATH
export PATH=/home/netlab/go/bin:$PATH
export PATH=/home/netlab/Downloads/camino/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/ebloc-broker/bash_scripts:$PATH
export PATH=$HOME/personalize/scripts:$PATH
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"
echo $PATH | grep -q '/usr/local/bin'; [ $? -ne 0 ] && export PATH=/usr/local/bin:$PATH

source $HOME/venv/bin/activate
export IGNOREEOF=42
export BAT_PAGER="less -rR"
export LESS=FR
export GPG_TTY=$(tty)

# export PYTHONDONTWRITEBYTECODE="1"

SLURMUSER="netlab"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

source ~/venv/bin/activate
source $HOME/.cargo/env
source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/z/z.sh

# ps + grep.
psgrep() {
  local pids
  pids=$(pgrep -f $@)
  if ! [[ $pids ]]; then
    echo "No processes found." >&2; return 1
  fi
  ps up $(pgrep -f $@)
}

export PROMPT_COMMAND='history -a'

alias psg=psgrep

[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh

FILE=$HOME/.aliases
if test -f "$FILE"; then
    source $FILE
fi

if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
    tmux -CC new -A -s main
    # tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi

FILE=$HOME/personalize/bin/gitprompt.sh  # https://github.com/magicmonty/bash-git-prompt
if [ -f $FILE ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source $FILE
fi

export GIT_PS1_SHOWDIRTYSTATE=1
export PS1="\w$(__git_ps1 " (%s)")\$ "
