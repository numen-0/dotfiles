#!/bin/sh
set -eu
# copy files into current dotfiles repo, preserving paths

backup=true

DIR="."
BK_DIR="$DIR/.bk/$(date +%s)"

TARGETS="
$HOME/.config/X11
$HOME/.config/alacritty/
$HOME/.config/bash
$HOME/.config/git
$HOME/.config/nvim
$HOME/.config/vim
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

    echo "[grabbing]: $target > $rel"

    # backup existing
    [ -e "$dest" ] && {
        $backup && {
            bk_dir="$BK_DIR/$rel"
            mkdir -p "$(dirname "$bk_dir")"
            mv -v "$dest" "$bk_dir"
        }
        rm -rf $dest
    }

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

$backup && echo "[backup]: generated at '$BK_DIR'"
