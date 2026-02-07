#!/bin/zsh

########################
# Move old dotfile and create symlinks for dot files
########################

# Variables
dir="$(cd "$(dirname "$0")" && pwd)" # directory for new dotfiles
olddir=~/old_dotfiles # directory to move previous dot files
files="zshrc vimrc vim zshrc_local" # dot files to be installed
mv_color="\033[35m"
ln_color="\033[34m"
old_color="\033[33m"
new_color="\033[32m"
default_color="\033[37m"
done="\033[31mDone\033[37m"

#Error handling function
set -e

#Git stuff
echo "Git submodule ${mv_color}init ${default_color}&& git submodule ${mv_color}update${default_color}... "
git submodule init && git submodule update || echo "\033[33mWarning: some submodules failed to initialize (continuing anyway)\033[37m"
echo "$done"

# create dotfiles_old in ~
echo "Creating ${old_color}$olddir ${default_color}for backup of any existing dotfiles in ~... "
mkdir -p $olddir
echo "$done"

#Create .zshrc_local for local zsh configurations
echo "Creating ${new_color}~/.zshrc_local${default_color} to store local zsh configurations in... "
touch zshrc_local
echo "$done"

# change directory into dotfiles
echo "Changing to ${new_color}$dir ${default_color}directory... "
cd $dir
echo "$done"

# move old dotfiles into old_dotfiles directory AND create symlinks for new dotfiles directory
for file in $=files; do
  set +e
  ls ~/.$file > /dev/null 2>&1
  if [[ "$?" == 0 ]]; then
    set -e
    echo "Moving old ${mv_color}$file ${default_color}from ~ to ${old_color}$olddir${default_color}... "
    mv ~/.$file $olddir/ # 2>&1 # 2> /dev/null
    echo "$done"
  else
    set -e
  fi
  echo "Creating symlinks for new dotfile: ${ln_color}$file${default_color}... "
  ln -s $dir/$file ~/.$file #2>&1
  echo "$done \n"
done

echo "Sourcing the new zshrc... "
source ~/.zshrc
echo "$done"


trap "echo 'Finished. Symlinks to dotfiles configured. Old dotfiles located in directory: ${old_color}${olddir}${default_color}'" EXIT
# Done
