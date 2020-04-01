#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Installing bin folder into $HOME/bin"
for f in "$SCRIPT_DIR"/bin/*; do
  filename=$(basename "$f")
  echo "$f -> $HOME/bin/$filename"
  ln -fs "$f" "$HOME/bin/$filename"
done

echo "Installing dotfiles"
config_src=( gitconfig zshrc settings.json )
config_dest=( .gitconfig .zshrc .config/Code/User/settings.json )
n=$((${#config_src[@]} - 1))
for i in $(seq 0 $n); do
  echo "$SCRIPT_DIR/dotfiles/${config_src[$i]} -> $HOME/${config_dest[$i]}"
  ln -sf "$SCRIPT_DIR/dotfiles/${config_src[$i]}" "$HOME/${config_dest[$i]}"
done
