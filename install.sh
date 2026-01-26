#!/bin/zsh
set -e

mkdir -p "$HOME/bin"

# Link zsh scripts to ~/bin
for file in *.zsh(N); do
    ln -sf "$PWD/$file" "$HOME/bin/$file"
    echo "linked: $file -> $HOME/bin/$file"
done

