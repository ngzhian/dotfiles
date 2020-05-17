# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias -- -="cd -"
alias g='git status'
alias d='git diff'

alias xclipb='xclip -selection clipboard'

alias v='vim'

# chrome/v8/wasm {{{
alias gm='$HOME/ssd1/v8/v8/tools/dev/gm.py'
alias adb='$HOME/ssd1/v8/v8/third_party/android_sdk/public/platform-tools/adb'
alias dd8='$HOME/ssd1/v8/v8/out/x64.debug/d8 --experimental-wasm-simd'
alias dd8r='$HOME/ssd1/v8/v8/out/x64.release/d8 --experimental-wasm-simd'
# chrome/v8/wasm }}}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# }}}
