#Simple aliases
unamestr=`uname` #ls options by operating system
if [[ "$unamestr" == "Linux" ]]; then
  alias ls="ls --color"
elif [[ "$unamestr" == "Darwin" ]]; then
  alias ls="ls -G"
fi
alias sbashrc="source ~/.bashrc" #re-source bashrc
alias vbashrc="vim ~/.bashrc" #edit bashrc
alias cbashrc="cat ~/.bashrc" #display bashrc
alias p="fc -s" #run previous command
alias external="curl ipecho.net/plain; echo"
alias ipconfig="ifconfig"
alias bits="uname -m"
alias dir="ls -l"

#Exports
export EDITOR=vim
source ~/.bashrc_local

#colors
DEFAULT="[37m"
MAGENTA="[35m"
GREEN="[32m"
ORANGE="[33m"
BLUE="[34m"
CYAN="[36m"
RED="[31m"

#Custom prompt
function Git_status (){
	git status --porcelain | \
	awk 'BEGIN {TOCOMMIT=0; TOADD=0} \
	$1 == "??" { TOADD++ } \
	$1 != "??" { TOCOMMIT++ } \
	END { printf "\033[37m[ \033[31m?\033[37m"\
    TOADD" \033[31m!\033[37m"TOCOMMIT" ]" }'
}

function Git_branch (){
	BRANCH=$(git symbolic-ref -q HEAD 2> /dev/null) && \
	echo -e "\033[37min \033${CYAN}${BRANCH##*/}$(Git_status) "
}

export PS1='\[\e${MAGENTA}\]\u\[\e${DEFAULT}\]\
@\[\e${MAGENTA}\]\h\[\e${DEFAULT}\]: \
\[\e${GREEN}\]\w \[\e${BLUE}$(Git_branch)\]\
\[\e${DEFAULT}\]\n\$ '

##Helpful functions##
#Git Add, commit, and push

function gac() {
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

	#Add, commit, and push
	echo -e "\033[36m------git add------\033[37m" &&
	git add . && 
	echo -e "\n\033[36m------git commit------\033[37m" &&
	git commit -am "$COMMIT" &&
	echo -e "\n\033[36m------push------\033[37m" &&
	git push origin master
}

#Git commands
for d in `find ~/Documents -not -path "*/\.*/\.git" -name ".git"`
do 
    path=${d%/*}
    name=${path##*/}
    alias $name="cd $d/..
    git status"
done

#add something to path
function path (){
	export PATH="$path:$1"
}

function switch(){
  if [ "$#" == 2 ]; then 
    export SWITCHPATHS="${1} ${2}"
  else
    P=${SWITCHPATHS%% *}
    PA=${SWITCHPATHS##* }
    echo "P: $P, PA: $PA"
    if [ "$P" == "$PWD" ]; then
      cd $PA
    elif [ "$PA" == "$PWD" ]; then
      cd $P 
    fi
  fi
}
#cd & ls
function cs () {
	cd "$@" && ls
}

#launch a new terminal
function start () {
  gnome-terminal
}

function cpr (){
  g++ $1 && ./a.out
}
