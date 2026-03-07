#
# mini.bashrc
#

case "$-" in
  *i*) ;;
  *) return ;;
esac

# efimeral definitions

UTILS="ping curl wget nc nmap"
R="\e[0m"
B="\e[1m"
C0="\e[1;7;93m"
C1="\e[1;32m"
C2="\e[1;93m"
C3="\e[1;33m"
C4="\e[1m"
OK="\e[1;7;92m"
FAIL="\e[1;7;31m"

HOST="${HOSTNAME%%.*}"
IP="$(ip route get 1.1.1.1 | head -n 1 | cut -d " " -f7)"
[ -z "$HOST" ] && HOST="$(cat /proc/sys/kernel/hostname 2>/dev/null)"
[ -z "$HOST" ] && HOST="$(uname -n 2>/dev/null)"
[ -z "$HOST" ] && HOST="$IP"

have() { command -v "$1" >/dev/null 2>&1; }

set_editor() {
    for editor in nvim vim vi nano; do
        if have "$editor"; then
            export EDITOR="$editor"
            return 0
        fi
    done; return 1
} && set_editor && unset set_editor

# info pannel

printf "${B}%-62s${R}\n" " |env|" | tr " " "-" | tr "|" " "
(
    print() {
        C5="\e[1;34m"; C6="\e[1;92m"
        r=$(printf '\033[0m') # +4

        printf " ${C5}%-12s ${C6}%-15s${R} \n" "${1:-?}${r}:" "$2"
    }
    ram() {
        grep "$1" /proc/meminfo \
            | sed "s/\S*\s*\(\S*\)\(.\)..... .*/\1.\2/"
    }
    mem() {
        df -h / \
            | tail -n 1 \
            | tr -s " " \
            | cut -d " " -f2,3 \
            | sed "s/\(\S*\). \(\S*\)./\2\/\1 G/"
    }

    s="$(cat /proc/uptime)";   s="${s%%.*}";
    d="$((s / 60 / 60 / 24))"; h="$((s / 60 / 60 % 24))";
    m="$((s / 60 % 60))";      s="$((s % 60))";
    [ "$d" -gt 0 ] && d="${d}d " || d=""
    h="${h}h"
    m="${m}m"


    . /etc/os-release

    print "id"      "$(whoami)@${HOST}"
    print "ip"      "${IP}"
    print "os"      "$(printf "%s" "$PRETTY_NAME" | tr '[:upper:]' '[:lower:]')"
    print "uptime"  "$d$h $m"
    print "ram"     "$(ram MemFree)/$(ram MemTotal) G"
    print "mem"     "$(mem)"
    print "shell"   "${SHELL}"
) | paste - -

printf "${B}%-62s${R}\n" " |cmd-check|" | tr " " "-" | tr "|" " "
check_utils() {
    for u in "$@"; do
        have "$u" \
            && printf " ${OK}[ OK ]${R} %-12s\n"   "$u" \
            || printf " ${FAIL}[FAIL]${R} %-12s\n" "$u"
    done | paste - - -
} && check_utils "${EDITOR:-vi}" $UTILS && unset check_utils
printf "${B}%62s${R}\n" "" | tr " " "-"

# config

set -o vi
bind "set completion-ignore-case on"
bind -x '"\C-g":"fg"'

alias ..='cd ..'
alias ls='ls -A --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color'
alias tree='find . -type d | sed "s.[^/]*/. | .g"'

# PS1

PROMPT_COMMAND='LAST_EXIT=$?;'
ps1_icon() {
    [ 0 -eq "$LAST_EXIT" ] \
        && printf '\e[0;1;92m :D ' \
        || printf '\e[0;1;31m xD '
}

PS1="${R}${C0}[\$(date +'%H:%M')]${R} ${C1}${USER}${C2}@${C3}${HOST}${R} ${C4}\W${R}\$(ps1_icon)${R}"
export PS1

# unset efimeral

for v in R B C0 C1 C2 C3 C4 OK FAIL UTILS HOST have IP; do
    unset "$v"
done

