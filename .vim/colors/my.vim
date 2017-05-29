" Vim color file
"
" Set 'background' back to the default.  The value can't always be estimated
" and is then guessed.
hi clear Normal
set bg&

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

" my custom colorscheme based off the default
let colors_name = "my"

" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors

" or maybe lightgray
hi Comment	ctermfg=247
hi LineNr ctermfg=lightgrey
hi Keyword ctermfg=104
hi String ctermfg=71

" vim: sw=2
