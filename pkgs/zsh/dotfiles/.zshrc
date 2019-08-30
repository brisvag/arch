# Path to your oh-my-zsh installation.
export ZSH="/home/brisvag/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bira_venvfix"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	common-aliases
#	lol
	git
	colored-man-pages
	colorize
	pip
	python
	command-not-found
	archlinux
	virtualenv
	web-search
	zsh-autosuggestions # custom
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

autoload -Uz compinit
compinit # added to fix missing completion stuff, such as yay

# Aliases and such

alias sudo='sudo '
alias l='ls -lFh --group-directories-first'
alias la='ls -lFhA --group-directories-first'
alias lt='ls -lFrth --group-directories-first'
alias rm='rm -I'
alias vi='vim --servername vim'
alias vim='vim --servername vim'
alias r='ranger'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
mcd () {mkdir "$1" && cd "$1"}
alias :q='exit'
alias q='exit'
alias open='xdg-open'
alias adt='/opt/mgltools/bin/adt'
alias act='conda activate'
alias dact='conda deactivate'
destroy () {ps ax|grep $1|awk '{print $1}' | xargs -L 1 -I X kill X}
alias stir="python -m stir"
alias gibberify="python -m gibberify"
gam () {git add "$1" && git commit -m "$2"} # need quotes on the message
alias weather='curl -s "v2.wttr.in"'

# Share history between open terminals
setopt inc_append_history

# Fix behaviour of home/end buttons
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char

# base paths
export PATH="$HOME/.local/bin:$PATH"

# Source and export stuff
source /usr/bin/GMXRC.zsh
# this removes /usr/lib from the main path (gmxrc's fault), cause it created a lot of problems
unset LD_LIBRARY_PATH 

source /opt/miniconda3/etc/profile.d/conda.sh
#export PATH="$HOME/builds/miniconda3/bin:$PATH"
#export LD_LIBRARY_PATH="$HOME/builds/miniconda3/lib:$LD_LIBRARY_PATH"

# Modeller paths
export HHLIB="$HOME/builds/hh-suite/build"
export PATH="$HHLIB/bin:$HHLIB/scripts:$PATH"
export PYTHONPATH="$HOME/builds/modeller/modlib:$HOME/builds/modeller/lib/x86_64-intel8/python3.3:$PYTHONPATH"
export LD_LIBRARY_PATH="$HOME/builds/modeller/lib/x86_64-intel8:$LD_LIBRARY_PATH"

# DOCKING paths
export MGLROOT="/opt/mgltools"
export PYTHONPATH="$MGLROOT/MGLToolsPckgs:$PYTHONPATH"
#export PATH="$MGLROOT/bin:$PATH"
export LD_LIBRARY_PATH="$MGLROOT/lib/python2.7:$LD_LIBRARY_PATH"

# Pymol paths
export FREEMOL="$HOME/.cache/yay/freemol-svn/freemol-svn/freemol"
export PYTHONPATH="$HOME/.cache/yay/freemol-svn/freemol-svn/freemol/libpy:$PYTHONPATH"

# TMP STUFF
# openage
#export PYTHONPATH="$HOME/git/openage:$PYTHONPATH"
# stir & garnish
export PYTHONPATH="$HOME/git/stir:$HOME/git/garnish:$PYTHONPATH"
# gibberify
export PYTHONPATH="$HOME/git/gibberify:$PYTHONPATH"

# added by travis gem
[ -f /home/brisvag/.travis/travis.sh ] && source /home/brisvag/.travis/travis.sh
