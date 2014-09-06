for dir in /usr/local/bin "$DOTHOME/bin" .git/safe/../../bin .git/bin; do
  case "$PATH:" in
    *:"$dir":*) PATH="`echo "$PATH"|sed -e "s#:$dir##"`" ;;
  esac
  case "$dir" in
    /*) [ ! -d "$dir" ] || PATH="$dir:$PATH" ;;
    *) PATH="$dir:$PATH" ;;
  esac
done

for dir in /usr/local/sbin /opt/local/sbin /usr/X11/bin; do
  case ":$PATH:" in
    *:"$dir":*) ;;
    *) [ ! -d "$dir" ] || PATH="$PATH:$dir" ;;
  esac
done
