if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

# OPAM configuration
. /Users/ngzhian/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

###-tns-completion-start-###
if [ -f /Users/ngzhian/.tnsrc ]; then 
    source /Users/ngzhian/.tnsrc 
fi
###-tns-completion-end-###
