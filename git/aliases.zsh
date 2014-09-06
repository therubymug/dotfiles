# ~/aliases.zsh
# vim:set ft=sh sw=2 sts=2:

git() {
  [ -f "$HOME/.hitch_export_authors" ] && . "$HOME/.hitch_export_authors"
  if command -v hub >/dev/null; then
    command hub "$@"
  else
    command git "$@"
  fi
}

# Show git commit authorship totals. Options are forwarded to git log
#
# Usage:
# $ contributions                    # for entire repo history
# $ contributions -n30               # authorship for last 30 commits
# $ contributions --since="last week"
contributions () {
  prog='BEGIN{ FS=",? and |, "; OFS=""}
  END{ for(name in count) print count[name],"|",name; print NR,"|TOTAL"}
  { for(i=1; i<=NF; i++) { count[$i]++; } }'

  git log --format="%an" $@ | awk $prog | sort -nr | column -t -s '|'
}

# git_prompt_info accepts 0 or 1 arguments (i.e., format string)
# returns text to add to bash PS1 prompt (includes branch name)
git_prompt_info () {
  local g="$(git rev-parse --git-dir 2>/dev/null)"
  if [ -n "$g" ]; then
    local r
    local b
    local d
    local s
    # Rebasing
    if [ -d "$g/rebase-apply" ] ; then
      if test -f "$g/rebase-apply/rebasing" ; then
        r="|REBASE"
      fi
      b="$(git symbolic-ref HEAD 2>/dev/null)"
    # Interactive rebase
    elif [ -f "$g/rebase-merge/interactive" ] ; then
      r="|REBASE-i"
      b="$(cat "$g/rebase-merge/head-name")"
    # Merging
    elif [ -f "$g/MERGE_HEAD" ] ; then
      r="|MERGING"
      b="$(git symbolic-ref HEAD 2>/dev/null)"
    else
      if [ -f "$g/BISECT_LOG" ] ; then
        r="|BISECTING"
      fi
      if ! b="$(git symbolic-ref HEAD 2>/dev/null)" ; then
        if ! b="$(git describe --exact-match HEAD 2>/dev/null)" ; then
          b="$(cut -c1-7 "$g/HEAD")..."
        fi
      fi
    fi

    # Dirty Branch
    local newfile='?? '
    if [ -n "$ZSH_VERSION" ]; then
      newfile='\?\? '
    fi
    d=''
    s=$(git status --porcelain 2> /dev/null)
    [[ $s =~ "$newfile" ]] && d+='+'
    [[ $s =~ "M " ]] && d+='*'
    [[ $s =~ "D " ]] && d+='-'

    printf "${1-"(%s) "}" "${b##refs/heads/}$r$d"
  fi
}

alias gap='git add -p'
alias gc='git commit -v'
alias gd='git diff --no-ext-diff'
alias gdc='gds'
alias gds='git diff --staged --no-ext-diff'
alias gnap='git add -N . && git add -p'
alias gpr='git pull --rebase --prune'
alias gst='git status'
