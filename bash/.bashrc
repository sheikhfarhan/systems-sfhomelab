#!/usr/bin/env bash

# --- GLOBAL SETTINGS ---
# Initialize simple flags
iatest=$(expr index "$-" i)

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Enable bash programmable completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

# --- EXPORTS & PATHS ---
export HISTFILESIZE=10000
export HISTSIZE=500
export HISTTIMEFORMAT="%F %T "
export HISTCONTROL=erasedups:ignoredups:ignorespace
shopt -s checkwinsize
shopt -s histappend
PROMPT_COMMAND='history -a'

# XDG Paths
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Default Editor
export EDITOR=nano
export VISUAL=nano

# Colors
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

# Manpage Colors
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# --- ALIASES ---

# General
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v' # Safety first!
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
alias vi='nvim'
alias vim='nvim'
alias svi='sudo nvim'

# Edit this .bashrc file
alias ebrc='nano ~/.bashrc'
alias reload='source ~/.bashrc'

# LS Variations
alias la='ls -Alh'                # show hidden files
alias ls='ls -aFh --color=always' # add colors and file type extensions
alias lx='ls -lXBh'               # sort by extension
alias lk='ls -lSrh'               # sort by size
alias lc='ls -ltcrh'              # sort by change time
alias lu='ls -lturh'              # sort by access time
alias lr='ls -lRh'                # recursive ls
alias lt='ls -ltrh'               # sort by date
alias lm='ls -alh |more'          # pipe through 'more'
alias lw='ls -xAh'                # wide listing format
alias ll='ls -Fls'                # long listing format
alias labc='ls -lap'              # alphabetical sort
alias lf="ls -l | egrep -v '^d'"  # files only
alias ldir="ls -l | egrep '^d'"   # directories only
alias lla='ls -Al'                # List and Hidden Files
alias las='ls -A'                 # Hidden Files
alias lls='ls -l'                 # List

# Navigation
alias home='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias bd='cd "$OLDPWD"' # Back directory
alias cdhomelab='cd /mnt/pool01/homelab'
alias cdservices='cd /mnt/pool01/homelab/services'
alias cdpool01='cd /mnt/pool01'
alias cdmedia='cd /mnt/pool01/media'

# System
alias diskspace="du -S | sort -n -r | more"
alias folders='du -h --max-depth=1'
alias mountedinfo='df -hT'
alias openports='netstat -nape --inet'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# Utilities
alias please='sudo'
alias multitail='multitail --no-repeat -c'
alias yayf="yay -Slq | fzf --multi --preview 'yay -Sii {1}' --preview-window=down:75% | xargs -ro yay -S"
alias docker-clean=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '
alias dockerupf='docker compose up -d --force-recreate'
alias docker-reload-caddy='docker compose exec caddy caddy reload --config /etc/caddy/Caddyfile'
alias dockerexec='docker exec -it' 


# Grep -> Ripgrep (rg) if available
if command -v rg &> /dev/null; then
    alias grep='rg'
else
    alias grep="/usr/bin/grep $GREP_OPTIONS"
fi

# Bat vs Batcat (Debian compatibility)
if command -v bat &> /dev/null; then
    alias cat='bat'
elif command -v batcat &> /dev/null; then
    alias cat='batcat'
fi

# --- FUNCTIONS ---

# Extract archives wrapper
extract() {
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf $archive ;;
			*.tar.gz) tar xvzf $archive ;;
			*.bz2) bunzip2 $archive ;;
			*.rar) rar x $archive ;;
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;
			*.tbz2) tar xvjf $archive ;;
			*.tgz) tar xvzf $archive ;;
			*.zip) unzip $archive ;;
			*.Z) uncompress $archive ;;
			*.7z) 7z x $archive ;;
			*) echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Create directory and enter it
mkdirg() {
	mkdir -p "$1"
	cd "$1"
}

# Copy file with progress bar
cpp() {
    set -e
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 | awk '{
        count += $NF
        if (count % 10 == 0) {
            percent = count / total_size * 100
            printf "%3d%% [", percent
            for (i=0;i<=percent;i++) printf "="
            printf ">"
            for (i=percent;i<100;i++) printf " "
            printf "]\r"
        }
    }
    END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# --- INITIALIZATION ---

# Run Fastfetch if interactive
if [[ $- == *i* ]] && [ -f /usr/bin/fastfetch ]; then
	fastfetch
fi

# Initialize Tools
# (Ensure zoxide is installed!)
eval "$(starship init bash)"
eval "$(zoxide init bash)"

# Bind Ctrl+f to 'zi' (Zoxide interactive)
if [[ $- == *i* ]]; then
    bind '"\C-f":"zi\n"'
fi

export PATH=$PATH:"$HOME/.local/bin:$HOME/.cargo/bin"