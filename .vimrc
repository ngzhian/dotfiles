set enc=utf-8
set nocompatible
filetype off

" temp map to test my colorscheme
:nmap <Leader>c :colorscheme my<cr>

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'SirVer/ultisnips'
Plugin 'airblade/vim-gitgutter'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'
Plugin 'Raimondi/delimitMate'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'
Plugin 'tpope/vim-unimpaired'
Plugin 'godlygeek/tabular'

" tmux
Plugin 'benmills/vimux'
Plugin 'christoomey/vim-tmux-navigator'

" javascript
Plugin 'pangloss/vim-javascript'

" python related
" Plugin 'fisadev/vim-isort'
" Plugin 'jmcantrell/vim-virtualenv'
" Plugin 'klen/python-mode' " runs slow on my com, disable it

" less related
" Plugin 'groenewege/vim-less'

" ultisnips snippets
Plugin 'honza/vim-snippets'

" scala
" Plugin 'derekwyatt/vim-scala'

" haskell
Plugin 'DanielG/ghc-mod'

" ocaml
Plugin 'rgrinberg/vim-ocaml'

call vundle#end()
filetype plugin indent on " enable fietype-specific indenting and pugins

syntax on   " enable syntax highlighting

let mapleader = ","
let maplocalleader = "\\"

" source $MYVIMRC reloads the saved $MYVIMRC
:nmap <Leader>s :source $MYVIMRC<cr>
" opens $MYVIMRC for editing, or use :tabedit $MYVIMRC
:nmap <Leader>vim :tabedit $MYVIMRC<cr>

:nmap <Leader>n :lnext<cr>
:nmap <Leader>p :lprev<cr>

" let base16colorspace=256 " Access colors present in 256 colorspace
set background=light " Setting light mode
" colorscheme base16-atelierforest

set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set number

augroup myfiletypes
    autocmd!
    autocmd FileType javascript setlocal sw=2
    autocmd FileType html setlocal sw=2
    autocmd FileType htmldjango setlocal sw=2
    autocmd FileType ocaml setlocal sw=2
    autocmd FileType ocaml setlocal commentstring=(*%s*)
    au BufRead,BufNewFile *.ml,*.mli compiler ocaml
    autocmd FileType markdown setlocal spell
    autocmd FileType markdown setlocal commentstring=<!--%s-->
augroup END

set backspace=indent,eol,start "backspace over these
" set cursorline cursorcolumn " precise targetting of words
set complete=.,w,b,u,U,t,i,d

set scrolloff=5 "keep at least 5 lines above/below

" Sane movements
nnoremap j gj
nnoremap k gk

" Search settings
set hlsearch " highlight all matches of a search
set incsearch " searches as you type

set list listchars=tab:↣↣,trail:∙,extends:>,precedes:<

" Turns off highlight using this key map
map <C-c> :noh<cr>

" Window switching
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" treats pattern as case insenstive when all small letters
set ignorecase smartcase

" disable folding for markdown files
let g:vim_markdown_folding_disabled=1

" Buffers
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> ]B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
nnoremap <leader>q :bufdo bd<CR>

set hidden

" Allows saving the file using Ctrl-S in normal and insert mode
" Note that this requires terminal to ignore Ctrl-S
" for most terminal just add this to your .bashrc
"     stty -ixon
" nnoremap <C-S> :<C-u>update<CR>
" inoremap <c-s> <c-o>:update<CR>
nnoremap <leader>a :update<CR>
inoremap jf <Esc>

" NERDTree config
let NERDTreeChDirMode=2
" maybe set NERDTreeRespectWildIgnore to 1, then can reuse wildignore
let NERDTreeRespectWildIgnore=1
" let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\~$']
let NERDTreeShowBookmarks=1
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

" vim-airline config
let g:airline_theme='hybrid'

" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"

" YouCompleteMe
" nnoremap <leader>d :YcmCompleter GoToDeclaration<CR>
" nnoremap <leader>g :YcmCompleter GoToDefinition<CR>

set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildignore+=*.pyc
set wildignore+=*.cmi,*.cmo
set wildignore+=*/node_modules/*
set wildignore+=*/build/*
set wildignore+=*/_build/*

" For ctrlp
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_funky_matchtype = 'path'

" For vim-gitgutter
let g:gitgutter_realtime = 0

" Syntastic file checkers config
let g:syntastic_python_checkers = ['python', 'pyflakes', 'pep8']
let g:syntastic_javascript_checkers = ['eslint', 'jshint', 'gjslint']
let g:syntastic_ocaml_checkers = ['merlin']

" Vimux
nnoremap <leader>vl :VimuxRunLastCommand<CR>
nnoremap <leader>vp :VimuxPromptCommand<CR>
nnoremap <leader>vq :VimuxCloseRunner<CR>

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Ocaml
" nnoremap <leader>ot :MerlinTypeOf<CR>
" nnoremap <leader>od :MerlinDestruct<CR>
" nnoremap <leader>od :MerlinShrinkEnclosing<CR>
" nnoremap <leader>od :MerlinGrowEnclosing<CR>
nnoremap <localleader>md :MerlinDestruct<CR>
" similar to how unimpaired binds keys
nnoremap [m :MerlinShrinkEnclosing<CR>
nnoremap ]m :MerlinGrowEnclosing<CR>

" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
" ## added by OPAM user-setup for vim / ocp-indent ## 0613ec865dd5ccfcd98e342c1d20be42 ## you can edit, but keep this line
if count(s:opam_available_tools,"ocp-indent") == 0
  source "/Users/ngzhian/.opam/4.02.3+buckle-master/share/vim/syntax/ocp-indent.vim"
endif
" ## end of OPAM user-setup addition for vim / ocp-indent ## keep this line
