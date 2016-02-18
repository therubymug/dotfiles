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

git_current_state () {
  local g="$(git rev-parse --git-dir 2>/dev/null)"
  local current_state

  if [ -d "$g/rebase-apply" ] ; then
    if test -f "$g/rebase-apply/rebasing" ; then
      current_state="|REBASE"
    fi
  elif [ -f "$g/rebase-merge/interactive" ] ; then
    current_state="|REBASE-i"
  elif [ -f "$g/MERGE_HEAD" ] ; then
    current_state="|MERGING"
  else
    if [ -f "$g/BISECT_LOG" ] ; then
      current_state="|BISECTING"
    fi
  fi

  printf "${current_state}"
}

git_local_branch () {
  local g="$(git rev-parse --git-dir 2>/dev/null)"

  local branch_name

  if [ -d "$g/rebase-apply" ] ; then
    branch_name="$(cat "$g/rebase-apply/head-name")"
  elif [ -f "$g/rebase-merge/interactive" ] ; then
    branch_name="$(cat "$g/rebase-merge/head-name")"
  elif [ -f "$g/MERGE_HEAD" ] ; then
    branch_name="$(git symbolic-ref HEAD 2>/dev/null)"
  else
    if ! branch_name="$(git symbolic-ref HEAD 2>/dev/null)" ; then
      if ! branch_name="$(git describe --exact-match HEAD 2>/dev/null)" ; then
        branch_name="$(cut -c1-7 "$g/HEAD")..."
      fi
    fi
  fi

  printf "${branch_name##refs/heads/}"
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

    b=$(git_local_branch)
    r=$(git_current_state)
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

    printf "${1-"(%s) "}" "${b}${r}${d}"
  fi
}

# We push the branch to origin after rebasing on master so it auto-closes the git pull req.
merge() {
  local git_interactive=''
  local prompt_before_pushing='true'
  local branch=$(git_local_branch)
  local uncommitted_changes
  uncommitted_changes=$(git status --porcelain 2> /dev/null)

  if [ -n "$1" ]; then
    case $1 in
      -i | i | --interactive | interactive)
        git_interactive="--interactive"
        ;;
      -h | --help | help )
        echo
        echo "Usage: merge [options]"
        echo
        echo "Merges your current branch onto master."
        echo
        echo "General options:"
        echo "  -i, --interactive            Rebase your branch interactively with master"
        echo "  -f, --no-prompts             Don't prompt me before pushing to master"
        echo
        echo "Common options:"
        echo "  -h, --help                   Show this message"
        echo
        return
        ;;
      -f | --force)
        prompt_before_pushing="do_not_prompt"
        ;;
    esac
  fi

  if [[ -n ${uncommitted_changes} ]]; then
    echo
    echo "You have un-committed changes on this branch"
    echo "Please commit or stash them before proceeding"
    echo
    return
  fi

  if [ "${branch}" = "master" ]; then
    echo
    echo "You can't merge *master* onto *master*"
    echo "Please checkout the branch you're wanting to merge and run \`merge\` again"
    echo
    return
  fi

  git checkout master
  git pull --rebase --prune
  git checkout ${branch}
  git rebase ${git_interactive} master
  git push --force origin ${branch}
  git checkout master
  git merge ${branch}

  echo
  git log --graph --oneline --decorate --color
  echo

  if [ "${prompt_before_pushing}" != "do_not_prompt" ]; then
    echo
    echo "Are you sure you want to push master to origin? (No/yes)"
    read push_to_origin
    case ${push_to_origin} in
      [yY] | [yY][Ee][Ss] )
        echo "Pushing master to origin"
        echo
        ;;
      *)
        echo "Did not push master to origin"
        echo
        return
        ;;
    esac
  fi

  git push origin master
  git checkout master
  git push origin --delete ${branch}
  git branch -D ${branch}
}

alias gap='git add -p'
alias gc='git commit -v'
alias gd='git diff --no-ext-diff'
alias gdc='gds'
alias gds='git diff --staged --no-ext-diff'
alias gnap='git add -N . && git add -p'
alias gpr='git pull --rebase --prune'
alias gst='git status'
