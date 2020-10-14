# https://github.com/junegunn/fzf#custom-fuzzy-completion
# Custom fuzzy completion for "gm" command
#   e.g. gm **<TAB>
_fzf_complete_gm() {
  _fzf_complete --multi --reverse --prompt="gm> " -- "$@" < <(
    # gm always needs a target, so force the user to supply 1 first, even though gm can recognize a
    # target if it is given later. Use a simplistic check based on length of the command line.
    [[ -e out/ ]] && ls out/
    # let's figure out the tests
    # cctests don't care about subdirectory, so everything is cctest/<file name without suffix>
    find test/cctest/ -type f -name 'test-*' | while read -r item; do name=$(basename -a -s ".cc" "$item"); echo "cctest/$name/*"; done
    # mjsunit tests care about directory structure, so it's mjsunit/path/to/file <no suffix>
    find test/mjsunit -type f -name '*.js' | while read -r item; do name="${item%.js}"; name2=${name#test/}; echo "$name2"; done
    # inspector tests care directory structure too
    find test/inspector -type f -name '*.js' | while read -r item; do name="${item%.js}"; name2=${name#test/}; echo "$name2"; done
    # Targets can still be specified, but for most use cases, 1 target is specified first, then
    # comes the test, so have the targets be the last on this list.
  )
}
# [ -n "$BASH" ] && complete -F _fzf_complete_gm -o default -o bashdefault gm

_my_complete_gm() {
    local cur dirs tests
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    dirs=$([[ -e out/ ]] && ls out/ | xargs)
    # try this hack, so that when we complete cctest/ we won't have a space at
    # the end, and can then trigger the following test completion.
    test_targets="cctest/1 cctest/2 mjsunit/1 mjsunit/2 inspector/1 inspector/2 unittests/1 unittests/2"

    # some support for fzf as well
    trigger=${FZF_COMPLETION_TRIGGER-'**'}

    case "$cur" in
        *"$trigger")
            _fzf_complete_gm
            ;;
        "cctest/"*)
            # cctests ignore directory structure, it's always "cctest/filename"
            tests=$(find test/cctest/ -type f -name 'test-*' -print0 | xargs -0 basename -a -s ".cc" |
                while read -r item; do printf "cctest/%q/* " "$item"; done)
            COMPREPLY=( $(compgen -W "$tests" -- "$cur") )
            ;;
        "unittests/"*)
            # unittests ignore directory structure, and file name, it's always "unittests/TestNameMatcher"
            tests=$(find test/unittests/ -type f -name 'test-*' -print0 | xargs -0 basename -a -s ".cc" |
                while read -r item; do printf "unittests/%q/* " "$item"; done)
            COMPREPLY=( $(compgen -W "$tests" -- "$cur") )
            ;;
        "mjsunit/"*)
            # mjsunit tests require directory structure, but does not have .js suffix
            tests=$(cd test && find mjsunit/ -type f -name '*.js' | while read -r item; do printf "%q/* " "${item%.js}"; done)
            COMPREPLY=( $(compgen -W "$tests" -- "$cur") )
            ;;
        "inspector/"*)
            # inspector tests require directory structure, but does not have .js suffix
            tests=$(cd test && find inspector/ -type f -name '*.js' | while read -r item; do printf "%q/* " "${item%.js}"; done)
            COMPREPLY=( $(compgen -W "$tests" -- "$cur") )
            ;;
        *)
            # by default, return the targets and test_targets
            COMPREPLY=( $(compgen -W "$dirs $test_targets" -- ${cur}) )
            ;;
    esac
}

[ -n "$BASH" ] && complete -F _my_complete_gm -o default -o bashdefault gm
