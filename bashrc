#Simple aliases
alias ls="ls -FG"
alias sbashrc="source ~/.bashrc"
alias vbashrc="vim ~/.bashrc"
alias cbashrc="cat ~/.bashrc"
alias back="echo $OLDPWD ; cd $OLDPWD"
alias c="clear"
#colors
DEFAULT="[37;40m"
MAGENTA="[35;40m"
GREEN="[32;40m"
ORANGE="[33;40m"
BLUE="[34;40m"
CYAN="[36;40m"
RED="[31;40m"

#Custom prompt
function Git_status (){
	git status --porcelain | \
	awk 'BEGIN {TOCOMMIT=0; TOADD=0} \
	$1 == "??" { TOADD++ } \
	$1 != "??" { TOCOMMIT++ } \
	END { printf "\033[37;40m[ \033[31;40m?\033[37;40m"\
    TOADD" \033[31;40m!\033[37;40m"TOCOMMIT" ]" }'
}
function Git_branch (){
	BRANCH=$(git symbolic-ref -q HEAD 2> /dev/null) && \
	echo -e "\033[37;40min \033${CYAN}${BRANCH##*/}$(Git_status) "
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
	echo -e "\033[36;40m------git add------\033[37;40m" &&
	git add . && 
	echo -e "\n\033[36;40m------git commit------\033[37;40m" &&
	git commit -m "$COMMIT" &&
	echo -e "\n\033[36;40m------push------\033[37;40m" &&
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

function p () {
  !-1
}

#launch a new terminal
function start () {
  osascript -e 'tell application "Terminal" to do script ""' | echo -e $1 \\c
}
#launch brackets
function brackets () {
	/Applications/Brackets.app/Contents/MacOS/./Brackets
}
