#!bin/bash

########################
# Move old dotfile and create symlinks for dot files
########################

# Variables
dir=~/dotfiles # directory for new dotfiles
olddir=~/old_dotfiles # directory to move previous dot files
files="bashrc vimrc vim bashrc_local" # dot files to be installed
mv_color="\033[35;40m"
ln_color="\033[34;40m"
old_color="\033[33;40m"
new_color="\033[32;40m"
default_color="\033[37;40m"
done="\033[31;40mDone\033[37;40m"

#Error handling function
set -e

#Git stuff
echo "Git submodule ${mv_color}init ${default_color}&& git submodule ${mv_color}update${default_color}... "
git submodule init
git submodule update
echo -e "$done"

# create dotfiles_old in ~
echo -e "Creating ${old_color}$olddir ${default_color}for backup of any existing dotfiles in ~... "
mkdir $olddir
echo -e "$done"

#Create .bashrc_local for local bash configurations
echo "Creating ~/.bashrc_local to store local bash configurations in... "
touch .bashrc_local
echo "$done"

# change directory into dotfiles
echo -e "Changing to ${new_color}$dir ${default_color}directory... "
cd $dir
echo -e "$done\n"

# move old dotfiles into old_dotfiles directory AND create symlinks for new dotfiles directory
for file in $files; do
  set +e
  ls ~/.$file > /dev/null 2>&1
  if [ "$?" == 0 ]; then
    set -e
    echo -e "Moving old ${mv_color}$file ${default_color}from ~ to ${old_color}$olddir${default_color}... "
    mv ~/.$file $olddir/ # 2>&1 # 2> /dev/null
    echo -e "$done"
  else
    set -e
  fi
  echo -e "Creating symlinks for new dotfile: ${ln_color}$file${default_color}... "
  ln -s $dir/$file ~/.$file #2>&1
  echo -e "$done \n"
done

echo "Sourcing the new bashrc... "
source ~/.bashrc
echo "$done"


trap "echo -e 'Finished. Symlinks to dotfiles configured. Old dotfiles located in directory: ${old_color}${olddir}'" EXIT
# Done
