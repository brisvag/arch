# Path to oh-my-zsh installation
export ZSH="/home/brisvag/.oh-my-zsh"

# theme
ZSH_THEME="bira_venvfix"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
	common-aliases
	git
	colored-man-pages
	colorize
	pip
	python
	command-not-found
	archlinux
	virtualenv
	web-search
	zsh-autosuggestions
	zsh-syntax-highlighting
)

# initialize some stuff
source $ZSH/oh-my-zsh.sh

# completion
autoload -Uz compinit
compinit # added to fix missing completion stuff, such as yay

# Share history between open terminals
setopt inc_append_history

# Fix behaviour of home/end buttons
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char


# SOURCES

# miniconda
source /opt/miniconda3/etc/profile.d/conda.sh

# gromacs completion
source /usr/bin/GMXRC.zsh
# this removes /usr/lib from the main path (gmxrc's fault), cause it created a lot of problems
unset LD_LIBRARY_PATH 

# travis-ci completion
[ -f /home/brisvag/.travis/travis.sh ] && source /home/brisvag/.travis/travis.sh


# PATHS AND OTHER EXPORTS

# base paths
export PATH="$HOME/.local/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# hh-suite and modeller
export HHLIB="$HOME/builds/hh-suite/build"
export PATH="$HHLIB/bin:$HHLIB/scripts:$PATH"
export PYTHONPATH="$HOME/builds/modeller/modlib:$HOME/builds/modeller/lib/x86_64-intel8/python3.3:$PYTHONPATH"
export LD_LIBRARY_PATH="$HOME/builds/modeller/lib/x86_64-intel8:$LD_LIBRARY_PATH"

# docking
export MGLROOT="/opt/mgltools"
export PYTHONPATH="$MGLROOT/MGLToolsPckgs:$PYTHONPATH"
export LD_LIBRARY_PATH="$MGLROOT/lib/python2.7:$LD_LIBRARY_PATH"

# pymol
export FREEMOL="$HOME/.cache/yay/freemol-svn/freemol-svn/freemol"
export PYTHONPATH="$HOME/.cache/yay/freemol-svn/freemol-svn/freemol/libpy:$PYTHONPATH"

# temporary exports
# openage
#export PYTHONPATH="$HOME/git/openage:$PYTHONPATH"
# stir & garnish
export PYTHONPATH="$HOME/git/stir:$HOME/git/garnish:$PYTHONPATH"
# gibberify
export PYTHONPATH="$HOME/git/gibberify:$PYTHONPATH"


# ALIASES AND SIMILAR

# basic aliases
alias sudo='sudo '	# space needed to sudo other aliases
alias l='ls -lFh --group-directories-first'
alias la='ls -lFhA --group-directories-first'
alias lt='ls -lFrth --group-directories-first'
alias rm='rm -I'
alias vi='nvim' #--servername vim'
alias vim='nvim' #--servername vim'
alias vimrc='vi $XDG_CONFIG_HOME/nvim/init.vim'
alias r='ranger'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
mcd () {mkdir "$1" && cd "$1"}
alias :q='exit'
alias q='exit'
alias open='xdg-open'
gam () {git add "$1" && git commit -m "$2"} # need quotes on the message
destroy () {ps ax|grep $1|awk '{print $1}' | xargs -L 1 -I X kill X}

# minor or temporary aliases
alias act='conda activate'
alias dact='conda deactivate'
alias weather='curl -s "v2.wttr.in"'
alias stir="python -m stir"
alias gibberify="python -m gibberify"
alias adt='/opt/mgltools/bin/adt'

