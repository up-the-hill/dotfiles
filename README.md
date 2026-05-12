# dotfiles

Dotfiles using git bare repository.

## Installation

```bash
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo ".dotfiles" >> .gitignore
git clone --bare https://github.com/up-the-hill/dotfiles.git $HOME/.dotfiles
dots checkout
```
