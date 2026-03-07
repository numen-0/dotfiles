#!/bin/sh
set -eu
# copy files into current dotfiles repo, preserving paths

DIR="$(pwd)"
TARGETS="
$HOME/.config/X11
$HOME/.config/git
$HOME/.config/nvim
$HOME/.config/vim
$HOME/.config/bash
$HOME/.local/programs/suckless
$HOME/.local/scripts/gbranch
$HOME/.local/scripts/gunterfetch
$HOME/.local/scripts/pop
$HOME/.local/scripts/powermenu
$HOME/.local/scripts/screenshot
$HOME/.local/scripts/snip
$HOME/.local/scripts/statusbar
$HOME/.local/scripts/title
$HOME/.local/scripts/weather
$HOME/stuff/pictures/wall
$HOME/stuff/templates/snip/.clang-format
$HOME/stuff/templates/snip/.editorconfig
$HOME/stuff/templates/snip/TODO.md
$HOME/stuff/templates/snip/bob
$HOME/stuff/templates/snip/dash.sh
$HOME/stuff/templates/snip/main.c
$HOME/stuff/templates/snip/mit.txt
$HOME/stuff/templates/snip/script.sh
$HOME/stuff/templates/snip/stb-2.0.h
"

STRIP="
$HOME/stuff
$HOME
"

# $1: src
grab() {
    src=$(realpath "$1") || return
    rel="$src"
    for prefix in $STRIP; do
        rel="${rel#"$prefix/"}"   # strip home prefix
    done
    dest="$DIR/$rel"
    target="$(basename "$src")"

    echo "grabbing: $target > $rel"

    # # backup existing
    # [ -e "$dest" ] && mv -v "$dest" "$dest.$(date +%s).bk"

    mkdir -vp "$(dirname "$dest")"
    cp -av "$src" "$dest"
}

die() {
    echo "$*" >&2
    exit 1
}

for t in $TARGETS; do
    [ -e "$t" ] || die "Invalid target '$t'"
    grab "$t"
done

