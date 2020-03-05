#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Installing bin folder into $HOME/bin"
for f in $(ls $SCRIPT_DIR/bin); do
  echo "$SCRIPT_DIR/bin/$f -> $HOME/bin/$f"
  ln -fs $SCRIPT_DIR/bin/$f $HOME/bin/$f
done

echo "Installing dotfiles"
for f in $(ls $SCRIPT_DIR/dotfiles); do
  echo "$SCRIPT_DIR/dotfiles/$f -> $HOME/.$f"
  ln -sf $SCRIPT_DIR/dotfiles/$f $HOME/.$f
done
