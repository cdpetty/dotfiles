# Simple aliases
# ***Note: computer specific aliases should be included in bashrc_local 
unamestr=`uname` # ls options by operating system
if [[ "$unamestr" == "Linux" ]]; then
  alias ls="ls --color" # Color ls
  alias start="gnome-terminal"
elif [[ "$unamestr" == "Darwin" ]]; then
  alias ls="ls -G" # Color ls
  alias start='open -a Terminal "`pwd`"' # Open a new terminal in same directory
fi
alias sbashrc="source ~/.bashrc" # re-source bashrc
alias vbashrc="vim ~/.bashrc" # edit bashrc
alias cbashrc="cat ~/.bashrc" # display bashrc
alias p="fc -s" # run previous command
alias external="curl ipecho.net/plain; echo" # get external ip address
alias ipconfig="ifconfig" # Why is it not ipconfig in unix?
alias bits="uname -m" # 32 or 64bit?
alias dir="ls -l" # The windows struggle
alias sl="ls $@ | rev" # LS games

# Exports
export EDITOR=vim
export PS1='\[\e${MAGENTA}\]\u\[\e${DEFAULT}\]\
@\[\e${MAGENTA}\]\h\[\e${DEFAULT}\]: \
\[\e${GREEN}\]\w \[\e${BLUE}$(Git_branch)\]\
\[\e${DEFAULT}\]\n\$ '

# Colors
DEFAULT="[37m"
MAGENTA="[35m"
GREEN="[32m"
ORANGE="[33m"
BLUE="[34m"
CYAN="[36m"
RED="[31m"

function Git_status (){
	git status --porcelain | \
	awk 'BEGIN {TOCOMMIT=0; TOMOD=0; TOADD=0} \
        { if ($1 == "??") { TOADD++ } \
        else if ($1 == "A") { TOCOMMIT++ } \
        else { TOMOD++ }} \
        END { printf "\033[37m[ \033[31m?\033[37m%s \033[31m%%\033[37m%s \033[31m!\033[37m%s ]", TOADD, TOMOD, TOCOMMIT }'
}

# Get current git branch
function Git_branch (){
	BRANCH=$(git symbolic-ref -q HEAD 2> /dev/null) && \
	echo -e "\033[37min \033${CYAN}${BRANCH#*heads/}$(Git_status) "
}

## Helpful functions ##
# Git Add, commit, and push
function gac() {
  # Get the commit message, no need to put message in quotes
	if [ "$#" == 0 ]; then
		echo "### No commit message supplied"
		echo -e "### Type commit message > \\c"
		read COMMIT
		if [ -z "$COMMIT" ]; then
			echo "***No commit message specifed. Process aborted***"
			kill -INT $$
		fi
	else
		COMMIT="$*"
	fi

	# Add, commit, and push
	echo -e "\033[36m------git add------\033[37m" &&
	git add . && 
	echo -e "\n\033[36m------git commit------\033[37m" &&
	git commit -m "$COMMIT" &&
	echo -e "\n\033[36m------push------\033[37m" &&
	git push
}

# Git commands
function git_commands(){
  for d in `find ~/Documents/Git -not -path "*/\.*/\.git" -name ".git"`
  do 
    path=${d%/*}
    name=${path##*/}
    alias $name="cd $d/.. \
      git status"
  done
}
# eval `git_commands &` &> /dev/null
git_commands

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
  if [ "$#" == 2 ]; then 
    export SWITCHPATHS="${1} ${2}"
  else
    P=${SWITCHPATHS%% *}
    PA=${SWITCHPATHS##* }
    # echo "P: $P, PA: $PA"
    if [ "$P" == "$PWD" ]; then
      cd $PA
    elif [ "$PA" == "$PWD" ]; then
      cd $P 
    else 
      cd $P
    fi
  fi
}

# Easily save a directory path for use in a nother terminal
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

# Local bash commands should be stored here
source ~/.bashrc_local 

