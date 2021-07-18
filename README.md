# dotfiles

Just a place to keep my personal dotfiles. These dotfiles should work on most linux systems as well as Mac OS X.

## Installation

Run the following command to initialise symlinks required for loading dotfiles functionality. 
Existing `.bashrc` and `.bash_profile` in your system will back backed up with suffix `.orig`.

    ./install

## Vim modules

New vim modules can be installed by cd'ing into the root of the repo and issuing:
git submodule add https://someurl.com/somerepo vim/bundle/somerepo

Make sure to add ignore = dirty to .gitmodules to avoid issues with helptags.

#### To remove a vim plugin:

1. Remove it from .gitmodules
2. Remove it from .git/config
3. Run git `rm --cached <path-to-module></path-to-module>`
