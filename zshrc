
# Simple aliases
# ***Note: computer specific aliases should be included in zshrc_local
unamestr=$(uname) # ls options by operating system
if [[ "$unamestr" == "Linux" ]]; then
  alias ls="ls --color" # Color ls
  alias start="gnome-terminal"
elif [[ "$unamestr" == "Darwin" ]]; then
  alias ls="ls -G" # Color ls
  alias start='open -a Terminal "$(pwd)"' # Open a new terminal in same directory
fi
alias szshrc="source ~/.zshrc" # re-source zshrc
alias vzshrc="vim ~/.zshrc" # edit zshrc
alias czshrc="cat ~/.zshrc" # display zshrc
alias p="fc -s" # run previous command
alias external="curl ipecho.net/plain; echo" # get external ip address
alias ipconfig="ifconfig" # Why is it not ipconfig in unix?
alias bits="uname -m" # 32 or 64bit?
alias dir="ls -l" # The windows struggle
alias sl="ls | rev" # LS games
alias remote="git config --get remote.origin.url"
alias comp="rm a.out ; g++ -std=c++11 *.cpp"
alias rm="rm -i"

# Zsh options
setopt PROMPT_SUBST      # allow command substitution in prompt
setopt AUTO_CD           # cd by typing directory name
setopt HIST_IGNORE_DUPS  # don't store duplicate history entries
setopt SHARE_HISTORY     # share history between sessions
setopt APPEND_HISTORY    # append to history file

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Completion
autoload -Uz compinit && compinit

# Exports
export EDITOR=vim
export PATH="$PATH:~/dotfiles/bin"

# Colors
DEFAULT="%f"
MAGENTA="%F{magenta}"
GREEN="%F{green}"
ORANGE="%F{yellow}"
BLUE="%F{blue}"
CYAN="%F{cyan}"
RED="%F{red}"

# Prompt
PROMPT='${MAGENTA}%n${DEFAULT}@${MAGENTA}%m${DEFAULT}: ${GREEN}%~ ${BLUE}$(Git_branch)${DEFAULT}
%# '

function Git_status (){
	git status --porcelain 2>/dev/null | \
	awk 'BEGIN {TOCOMMIT=0; TOMOD=0; TOADD=0} \
        { if ($1 == "??") { TOADD++ } \
        else if ($1 == "A") { TOCOMMIT++ } \
        else { TOMOD++ }} \
        END { printf "%%F{white}[ %%F{red}?%%F{white}%s %%F{red}%%%%%%F{white}%s %%F{red}!%%F{white}%s ]", TOADD, TOMOD, TOCOMMIT }'
}

# Get current git branch
function Git_branch (){
	local branch
	branch=$(git symbolic-ref -q HEAD 2>/dev/null) || return
	print -n "%F{white}in %F{cyan}${branch#refs/heads/}$(Git_status) "
}

## Helpful functions ##
# Git Add, commit, and push
function gac() {
  # Get the commit message, no need to put message in quotes
	if [[ "$#" == 0 ]]; then
		echo "### No commit message supplied"
		echo -n "### Type commit message > "
		read COMMIT
		if [ -z "$COMMIT" ]; then
			echo "***No commit message specifed. Process aborted***"
			kill -INT $$
		fi
	else
		COMMIT="$*"
	fi

	# Add, commit, and push
	echo "\033[36m------git add------\033[37m" &&
	git add . &&
	echo "\n\033[36m------git commit------\033[37m" &&
	git commit -m "$COMMIT" &&
	echo "\n\033[36m------push------\033[37m" &&
	git push
}

# Git commands
function git_commands(){
  for d in $(find ~/Documents/Git -not -path "*/\.*/\.git" -name ".git")
  do
    path=${d%/*}
    name=${path##*/}
    alias $name="cd $d/.. \
      git status"
  done
}
# eval `git_commands &` &> /dev/null
#git_commands

# Easier way to go back a directory
# .. = back one directory, ... = back two directories, etc to 10 possible directories
function dot_commands(){
  for x in {1..10}
  do
    a="."
    b="cd "
    for y in $(seq 1 $x)
    do
      a=$a.
      b=$b../
    done
    alias $a="$b"
  done
}
dot_commands

# add something to path
function path (){
	export PATH="$PATH:$1"
}

# Handy function to easily switch between two directories
function switch(){
  if [[ "$#" == 2 ]]; then
    export SWITCHPATHS="${1} ${2}"
  else
    P=${SWITCHPATHS%% *}
    PA=${SWITCHPATHS##* }
    # echo "P: $P, PA: $PA"
    if [[ "$P" == "$PWD" ]]; then
      cd $PA
    elif [[ "$PA" == "$PWD" ]]; then
      cd $P
    else
      cd $P
    fi
  fi
}

# Easily save a directory path for use in another terminal
function spwd(){
    working_dir=$(pwd)
    echo "Set epwd to $working_dir"
    export epwd="${working_dir}"
}

function gpwd(){
    cd $epwd
}

function lpwd(){
    echo $epwd
}


# cd & ls
function cs () {
	cd "$@" && ls
}

function cpr (){
  g++ $1 && ./a.out
}

# Local zsh commands should be stored here
[[ -f ~/.zshrc_local ]] && source ~/.zshrc_local

function tp (){
    NEW_DIR=$(teleprt $@)
    cd $NEW_DIR
}
export PATH="$HOME/.local/bin:$PATH"
