#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")"
DOTFILES_ROOT=$(pwd)

set -e

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

echo ""

link_file () {
  local src=$1 dst=$2
  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then
      user "File already exists: $(basename "$src"), what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
      read -n 1 action

      case "$action" in
        o )
          overwrite=true;;
        O )
          overwrite_all=true;;
        b )
          backup=true;;
        B )
          backup_all=true;;
        s )
          skip=true;;
        S )
          skip_all=true;;
        * )
          ;;
      esac
    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

link_dotfiles () {
  info "  Linking dotfiles"

  local overwrite_all=false backup_all=false skip_all=false
  # TODO: Would be nice to maitain excluded rules in a separate file or some nicer way
  for src in $(find "$DOTFILES_ROOT" -mindepth 1 -maxdepth 1 ! -name '.macos' ! -name '.osx' ! -name '.DS_Store' ! -name '.git' ! -name 'b*' ! -name 'LICENSE-MIT.txt' ! -name 'README.md' ! -name 'init')
  do
    	dst="$HOME/$(basename "${src}")"
    	link_file "$src" "$dst"
  done
}

# install_homebrew() {
#     # Check for Homebrew
#     if test ! $(which brew)
#     then
#       info "  Installing Homebrew for you."
#       ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)" > /tmp/homebrew-install.log
#     fi

#     info "  To install packages execute '~/brew.sh' "
#     echo ""
# }

link_dotfiles
# cp .gitconfig ~/.gitconfig  # copy so that global config doesnt affect us
#install_homebrew

# reload the shell
#exec $SHELL -l

# ------------------

# #!/usr/bin/env bash

# cd "$(dirname "${BASH_SOURCE}")";

# git pull origin master;

# function doIt() {
# 	rsync --exclude ".git/" \
# 		--exclude ".DS_Store" \
# 		--exclude ".osx" \
# 		--exclude "bootstrap.sh" \
# 		--exclude "README.md" \
# 		--exclude "LICENSE-MIT.txt" \
# 		-avh --no-perms . ~;
# 	source ~/.bash_profile;
# }

# if [ "$1" == "--force" -o "$1" == "-f" ]; then
# 	doIt;
# else
# 	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
# 	echo "";
# 	if [[ $REPLY =~ ^[Yy]$ ]]; then
# 		doIt;
# 	fi;
# fi;
# unset doIt;
