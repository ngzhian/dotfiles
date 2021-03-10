#!/bin/bash
# Creates a shell command `dev` that sets you up for development in a
# configurable project directory.
#
# Example:
#
#   $ dev chromium # will cd into chromium dir
#   $ dev c # works too
#
# To use this script:
#
#   1. copy this script somewhere, e.g. "$HOME/bin/dev.sh",
#   2. add `source $HOME/bin/dev.sh" to "$HOME/.bashrc"
#   3. open a new terminal and the command `dev` will be available there

function dev() {
  local topdir # location of project source code
  local ssddir

  if [[ -d "$HOME/ssd1" ]]; then
    ssddir="$HOME/ssd1"
  else
    ssddir="$HOME/src"
  fi

  if [[ $# -ne 1 ]]; then
    echo "wrong number of args" 1>&2
    return
  fi

  case $1 in
      # need to sync this tree if doing dev
      v8)
        topdir="$ssddir/v8/v8"
        ;;
      c|ch|chromium)
        topdir="$ssddir/chromium/src"
        ;;
      d|devtools)
        topdir="$ssddir/devtools/devtools-frontend"
        ;;
      s|simd)
        topdir="$HOME/src/simd"
        ;;
      spec)
        topdir="$HOME/src/webassembly-spec"
        ;;
      *)
        echo "idk" 1>&2
        return
        ;;
  esac
  if [[ -z "$topdir" ]]; then
    echo "topdir not set" 1>&2
    return
  fi
  if !  cd "$topdir"; then
    echo "cannot find $topdir" 1>&2
    return
  fi
}
