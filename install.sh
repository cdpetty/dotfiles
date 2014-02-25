#!bin/bash

########################
# Move old dotfile and create symlinks for dot files
########################

# Variables
dir=~/dotfiles # directory for new dotfiles
olddir=~/old_dotfiles # directory to move previous dot files
files="bashrc vimrc vim" # dot files to be installed
mv_color="\033[35;40m"
ln_color="\033[34;40m"
old_color="\033[33;40m"
new_color="\033[32;40m"
default_color="\033[37;40m"
done="\033[31;40mDone\033[37;40m"
# create dorfiles_old in ~
echo -e "Creating ${old_color}$olddir ${default_color}for backup of any existing dotfiles in ~... \\c"
mkdir -p $olddir
echo -e "$done"

# change directory into dotfiles
echo -e "Changing to ${new_color}$dir ${default_color}directory... \\c"
cd $dir
echo -e "$done\n"

# move old dotfiles into old_dotfiles directory AND create symlinks for new dotfiles directory
for file in $files; do
  echo -e "Moving old ${mv_color}$file ${default_color}from ~ to ${old_color}$olddir${default_color}... \\c"
    mv ~/.$file $olddir/ 2> /dev/null
    echo -e "$done"
    echo -e "Creating symlinks for new dotfile: ${ln_color}$file${default_color}... \\c"
    ln -s $dir/$file ~/.$file 2> /dev/null
    echo -e "$done \n"
done

# Done
