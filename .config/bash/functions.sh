#
# ~/.config/bash/functions.sh
#

# jump to project root
base() {
    [ "$PWD" == "$HOME" ] && return

    root="$(git rev-parse --show-toplevel 2>/dev/null)" || return

    [ "$PWD" == "$root" ] || cd "$root"
}

# PS1 && term_name
change_term_name() {
    printf "%b" "\033]0;$1\007";
}
parse_git_status() {
    [ -z "$(git status --porcelain 2>/dev/null)" ] || printf "[+]"
}
parse_git_offset() {
    c="$(git rev-list --count origin/main.."${1:-HEAD}" 2>/dev/null)"
    [ -z "$c" ] && return


    if [ 0 -eq "$c" ]; then
        c="$(git rev-list --count "${1:-HEAD}"..origin/main 2>/dev/null)"
        [ 0 -eq "$c" ] && return
        printf "<-%s>" 
    else
        printf "<+%s>" "$c"
    fi
}
parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
parse_git() {
    if git status 2>/dev/null 1>/dev/null; then
        branch="$(parse_git_branch)"
        status="$(parse_git_status)"
        offset="$(parse_git_offset "${branch}")"
        printf " ${branch}${status}${offset} "
    fi
}
parse_jobs() {
    c="$(jobs | wc -l)"
    [ "$c" -gt 0 ] && printf " ${c}j "
}
parse_venv() {
    [ -n "${VIRTUAL_ENV:-}" ] && printf " $(basename $VIRTUAL_ENV) "
}
parse_dir() {
    [ "$PWD" == "$HOME" ] && {
        printf "\e[0;1m ~ "
        return
    }

    root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
        printf "\e[0;1m %s " "$(basename "$PWD")"
        return
    }

    repo="$(basename "$root")"

    if [ "$PWD" == "$root" ]; then
        printf "\e[0;1m %s " "$repo"
    else
        rel="${PWD#$root/}"
        printf "\e[0;1m %s/\e[90m\e[0;90m%s " "$repo" "$rel"
        # printf "\e[0;1m %s/%s " "$repo" "$rel"
    fi
}

PROMPT_COMMAND='LAST_EXIT=$?;'
ps1_icon() {
    [ 0 -eq "$LAST_EXIT" ] \
        && printf '\e[0;1;92m :D \e[0m' \
        || printf '\e[0;1;31m xD \e[0m'
}
ps1_color() {
    [ 0 -eq "$LAST_EXIT" ] \
        && printf '\e[92m' \
        || printf '\e[31m'
}
_PS1=false
toggle() {
    if $_PS1; then
        _PS1=false
        export PS1='\[\e[0;92m\]$(ps1_icon)\[\e[0m\]'
    else
        _PS1=true
        export PS1='\[\e[1;7m\]\[\e[95m\]$(parse_venv)\[\e[31m$(parse_git)\[\e[35m\]$(parse_jobs)$(parse_dir)\[\e[0m\]\n$(ps1_icon)'
    fi
} && export toggle && toggle

# swap
swap() {
    if [ ! -f "$1" ]; then
        echo "swap: file must be a reg file, and exist '$1'"
        return 1
    elif [ ! -f "$2" ]; then
        echo "swap: file must be a reg file, and exist '$2'"
        return 1
    fi
    tmp_file="$(mktemp /tmp/numen.swap.XXXXXX)"
    mv "$1" "$tmp_file" && mv "$2" "$1" && mv "$tmp_file" "$2"
}

# extract - from https://gitlab.com/dwt1/dotfiles/-/blob/master/.bashrc
extract() {
    if [ -z "$1" ]; then
        cat <<EOF
Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>
       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]
       path must be relative!!!
EOF
        return 1
    fi

    for a in "$@"; do
        if [ ! -f "$a" ]; then echo "'$a' - file doesnt exist"; return 1; fi

        case "${a%,}" in
        *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                     tar xvf "$a"       ;;
        *.lzma)      unlzma ./"$a"      ;;
        *.bz2)       bunzip2 ./"$a"     ;;
        *.cbr|*.rar) unrar x -ad ./"$a" ;;
        *.gz)        gunzip ./"$a"      ;;
        *.cbz|*.epub|*.zip)       unzip ./"$a"       ;;
        *.z)         uncompress ./"$a"  ;;
        *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                     7z x ./"$a"        ;;
        *.xz)        unxz ./"$a"        ;;
        *.exe)       cabextract ./"$a"  ;;
        *.cpio)      cpio -id < ./"$a"  ;;
        *.cba|*.ace) unace x ./"$a"     ;;
        *)           echo "extract: '$a' - unknown archive method"
                     return 1 ;;
        esac
    done
}

# Cool navigation
VERBOSE_JUMP=true
selector() {
    # dmenu -c -l 10
    fzf --ansi --border=rounded --tiebreak=begin,length \
        --preview 'tree --gitignore --dirsfirst --sort=name {}'

}

N_PLACES="$(cat <<EOF
$(find "$HOME/.local/programs" -maxdepth 1 -type d)
$(find "$HOME/.local/programs/suckless" -maxdepth 1 -type d)
$(find "$HOME/stuff/code" -maxdepth 1 -type d)
$XDG_CONFIG_HOME
$XDG_CONFIG_HOME/bash
$XDG_CONFIG_HOME/vim
$XDG_CONFIG_HOME/nvim
$HOME/.local/scripts
EOF
)"
G_PLACES="$(cat <<EOF
$HOME/stuff
$HOME/stuff/.dotfiles
$HOME/stuff/bacup
$HOME/stuff/code
$HOME/stuff/documents
$HOME/stuff/downloads
$HOME/stuff/music
$HOME/stuff/pictures
$N_PLACES
EOF
)"

N_PLACES="$(printf "%b" "$N_PLACES" | sort -u)"
G_PLACES="$(printf "%b" "$G_PLACES" | sort -u)"

# go to path
g_() {
    JUMP="$(printf "%b" "$G_PLACES" | sort -f | selector | sed "s|~|$HOME|")"

    [ -d "$JUMP" ] && cd "$JUMP" && $VERBOSE_JUMP && pwd
}
# nvim to path
n_() {
    JUMP="$(printf "%b" "$N_PLACES" | sort -f | selector | sed "s|~|$HOME|")"

    [ -d "$JUMP" ] && cd "$JUMP" && { $VERBOSE_JUMP && pwd; $EDITOR; }
}

# shortcuts generator
SHORTCUTS_FILE="$XDG_CONFIG_HOME/bash/shortcuts.sh"
g_alias() {
    $VERBOSE_JUMP \
        && echo "alias g_$1='cd $2 && pwd'" >> "$SHORTCUTS_FILE" \
        || echo "alias g_$1='cd $2'" >> "$SHORTCUTS_FILE"
}
n_alias() {
    $VERBOSE_JUMP \
        && echo "alias n_$1='cd $2 && pwd && nvim'" >> "$SHORTCUTS_FILE" \
        || echo "alias n_$1='cd $2 && nvim'" >> "$SHORTCUTS_FILE"
}

bash_shortcut_gen() {
    cat <<EOF > "$SHORTCUTS_FILE"
#
# ~/.config/bash/shortcuts.sh
#
# file generated by ~/.config/bash/functions.sh - $(date +"%F %T")
#

EOF

    echo "# nvim ------------------------------------------------------------------" >> "$SHORTCUTS_FILE"
    for PLACE in $(printf "%b" "$N_PLACES" | sed "s|~|$HOME|"); do
        n_alias "${PLACE##*/}" "$PLACE"
    done

    echo "" >> "$SHORTCUTS_FILE"
    echo "# go --------------------------------------------------------------------" >> "$SHORTCUTS_FILE"
    for PLACE in $(printf "%b" "$G_PLACES" | sed "s|~|$HOME|"); do
        g_alias "${PLACE##*/}" "$PLACE"
    done

    (herbe "bash/functions" "shortcut file updated" &> /dev/null &)
}

###############################################################################
# update shortcuts
[ "$XDG_CONFIG_HOME/bash/functions.sh" -nt "$XDG_CONFIG_HOME/bash/shortcuts.sh" ] \
    && bash_shortcut_gen

# unset
unset -f bash_shortcut_gen
unset -f g_alias
unset -f n_alias

unset SHORTCUTS_FILE
