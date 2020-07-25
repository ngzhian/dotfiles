" {{{ TOC
" - Prologue
" - Plugins installation
" - General customizations
" - Plugin customization
" - Filetype/Language specific customizations
" - LSP customizations
" - Abbreviations
" - Misc helpers
" }}}

" Prologue {{{
" Enable modern Vim features not compatible with Vi spec.
set nocompatible

" Needed for now by Vundle
filetype off
" }}}

" {{{ Plugins installation
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
if isdirectory(expand('$HOME/.vim/bundle/Vundle.vim'))
  call vundle#begin()

  " let Vundle manage Vundle, required
  Plugin 'VundleVim/Vundle.vim'

  " tmux
  " Allows sending keys to another tmux pane from within vim
  Plugin 'benmills/vimux'
  " Allows using the same keys to navigate vim panes and tmux panes.
  " This overwrites Ctrl-{h,j,k,l}, which usually behaves the same as
  " non-Ctrl.
  Plugin 'christoomey/vim-tmux-navigator'

  " fuzzy find interface for files, buffers, history, etc.
  Plugin 'junegunn/fzf.vim'

  " quickly jump to a specific letter visible on the screen
  Plugin 'easymotion/vim-easymotion'

  " LSP related functionality
  " Needed for async commands to work right.
  Plugin 'prabirshrestha/async.vim'
  " LSP client
  Plugin 'prabirshrestha/vim-lsp'
  " Autocompletion
  Plugin 'prabirshrestha/asyncomplete.vim'
  " Use LSP as autocomplete source
  Plugin 'prabirshrestha/asyncomplete-lsp.vim'
  " Use buffer as autocomplete source
  Plugin 'prabirshrestha/asyncomplete-buffer.vim'
  " Use file names as autocomplete source
  Plugin 'prabirshrestha/asyncomplete-file.vim'
  " Use words in tmux panes for completion.
  Bundle 'wellle/tmux-complete.vim'

  if has('python3')
    " Track the engine.
    Plugin 'SirVer/ultisnips'
    " Snippets are separated from the engine. Add this if you want them:
    Plugin 'honza/vim-snippets'
    " UltiSnips source for asyncomplete.vim
    Plugin 'prabirshrestha/asyncomplete-ultisnips.vim'
  endif
  
  " Easily comment out lines/selection with gc
  Plugin 'tpope/vim-commentary'
  " Helpers to deal with 'surrounding' stuff
  Plugin 'tpope/vim-surround'
  " Vim plugin for Git, or Git plugin for Vim.
  Plugin 'tpope/vim-fugitive'

  call vundle#end()
else
  echomsg 'Vundle is not installed. You can install Vundle from'
      \ 'https://github.com/VundleVim/Vundle.vim'
endif
" }}}

" Customizations {{{
" Enable filetype detection and turn on plugin and indent files
filetype plugin indent on
" Enable syntax (lexcial) highlighting
syntax on
set enc=utf-8
set backspace=indent,eol,start  " Make backspace sane.
set scrolloff=5                 " Add top/bottom scroll margins.
set history=1000                " Remeber more command line history
set wildmenu                    " Enhanced completion.
set wildmode=list:longest       " Act like shell completion.
set splitbelow splitright       " Windows are created in the direction I read.
" Make hidden characters look nice when shown.
" doesn't really work without set list
set listchars=tab:▷\ ,eol:¬,extends:»,precedes:«
set colorcolumn=100
set fillchars=vert:│ " separator between windows
set noswapfile
set mouse="a" " Enable mouse, may be useful for terminal-debug.

" Slightly stolen from vim-unimpaired
nnoremap ]p :set paste<cr>
nnoremap [p :set nopaste<cr>
" More stolen from vim-unimpaired
" q is for (q)uickfix list
nnoremap ]q :cnext<cr>
nnoremap [q :cprev<cr>
nnoremap ]Q :cfirst<cr>
nnoremap [Q :clast<cr>

inoremap jj <C-c>:w<cr>
" }}}

" Search {{{
set hlsearch
set incsearch                   " Search incrementally.
" Turns off highlight using this key map
" map <C-c> :noh<cr>
" treats pattern as case insenstive when all small letters
set ignorecase smartcase
" }}}

" Indents {{{
set smartindent
set shiftwidth=2
set smarttab
set expandtab
" }}}

" Movement {{{
" Movements that ignore differences in visual v.s. actual lines
nnoremap j gj
nnoremap k gk

" The default mappings look for { or } on the first column, since most cpp
" files I edit don't use this K&R style, remap these to something somewhat
" useful.
nnoremap [[ ?{$<CR>:nohl<CR>
nnoremap ][ /{$<CR>:nohl<CR>
nnoremap ]] /}$<CR>:nohl<CR>
nnoremap [] ?}$<CR>:nohl<CR>
" }}}

" Buffers {{{
" Since I use buffers so much, have an easier mapping for switching.
nnoremap <silent> ]b :bn<cr>
nnoremap <silent> [b :bp<cr>
" }}}

" .vimrc {{{
" opens $MYVIMRC for editing, or use :tabedit $MYVIMRC
:nmap <Leader>vim :edit $MYVIMRC<cr>

" source when vimrc is updated
augroup ReloadVimrcGroup
  autocmd!
  autocmd FileType vim set foldmethod=marker
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END
" }}}

" Used to be NERDTree {{{
let g:netrw_banner = 0
nnoremap <leader>d :Lexplore<CR>
" }}}

" Vimux {{{
nnoremap <leader>vl :VimuxRunLastCommand<CR>
nnoremap <leader>vp :VimuxPromptCommand<CR>

" Runs the previous bash command in the runner pane
function! VimuxRunPrev()
  call VimuxOpenRunner()
  call VimuxSendKeys("C-p")
  call VimuxSendKeys("Enter")
endfunction

nnoremap <leader>l :call VimuxRunPrev()<CR>
" }}}

" fzf {{{
" use fzf to replace ctrl-p
set rtp+=~/.fzf
:nnoremap <C-p> :Files<CR>
" C-b is used to scroll window backwards, I usually use C-u for it.
:nnoremap <C-b> :Buffers<CR>
" search search history
:nnoremap <C-n> :History/<CR>
" search (e)x- commands history
:nnoremap <C-e> :History:<CR>
" }}}

" EasyMotion {{{
let g:EasyMotion_do_mapping = 0 " Disable default mappings
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap S <Plug>(easymotion-overwin-f)
" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
" }}}

" For asyncomplete {{{
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

if has('python3')
  " Ctrl-y is used to accept a suggestion from the completion menu,
  " with async complete, we use tab to change the selection.
  let g:UltiSnipsExpandTrigger="<c-y>"
  " call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
  "       \ 'name': 'ultisnips',
  "       \ 'whitelist': ['*'],
  "       \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
  "       \ }))
  au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
        \ 'name': 'ultisnips',
        \ 'whitelist': ['*'],
        \ 'completor': function('asyncomplete#sources#ultisnips#completor')
        \ }))

endif
" }}}

" LSP {{{
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '--background-index', '--clang-tidy']},
        \ 'whitelist': ['c', 'cpp'],
        \ })
endif

if executable('ocamllsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'ocamllsp',
        \ 'cmd': {server_info->['ocamllsp']},
        \ 'whitelist': ['ocaml'],
        \ })
endif

" From https://github.com/prabirshrestha/vim-lsp.
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=auto
    " follow how gd works by default, with is go to local declaration
    nmap <buffer> gd <plug>(lsp-declaration)
    nmap <buffer> gD <plug>(lsp-definition)
    " gr does some replacement of virtual characters, which I've never used.
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> <f2> <plug>(lsp-rename)
    " refer to doc to add more commands
    " TODO some other mapping?
    nmap <buffer> <f3> <plug>(lsp-document-diagnostics)

    " gq is already the formatting motion, but let's reuse it.
    " Since this is within a lsp install guard, it shouldn't affect the usual
    " functioning of gq in, say, commit messages.
    vnoremap <buffer> gq :<c-u>LspDocumentRangeFormatSync<cr>
    nnoremap <buffer> gq :<c-u>LspDocumentFormatSync<cr>

    " Might want this to be :LspWorkspaceSymbol, but try this out for now.
    nnoremap <buffer> K :LspHover<cr>
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_echo_cursor=1
" let g:lsp_diagnostics_float_cursor=1

" Logging to debug lsp
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')

" }}}

" Git/Hg commit messages {{{
augroup CommitMessages
  autocmd!
  autocmd FileType gitcommit set spell colorcolumn=72
  autocmd FileType hgcommit set spell colorcolumn=72
augroup END
" }}}

" Misc helper functions copied from some place. {{{
" :VC map to view output of map in a buffer
command! -nargs=1 VC  call ExecuteVimCommandAndViewOutput(<q-args>)

function! ExecuteVimCommandAndViewOutput(cmd)
  redir @v
  silent execute a:cmd
  redir END
  new
  set buftype=nofile
  put v
endfunction
" }}}

" {{{ Abberviations
abbreviate tf TurboFan
abbreviate lo Liftoff
" }}}

" bashrc {{{
augroup Bashrc
  autocmd!
  autocmd FileType sh set foldmethod=marker
augroup END
" }}}

" {{{ Syntax highlighting
" Some custom syntax to match tmux, originally from
" https://github.com/vim-airline/vim-airline-themes/blob/master/autoload/airline/themes/papercolor.vim
hi StatusLine cterm=bold ctermfg=240 ctermbg=255
hi StatusLineNC cterm=NONE ctermfg=255 ctermbg=24
" The separator color is slightly different from tmux, which is 31, not sure
" if that's what i want, let's try it and see.
hi VertSplit cterm=NONE ctermfg=250
hi ColorColumn ctermbg=255
hi Folded ctermfg=24 ctermbg=15
" }}}

" rst {{{
augroup Rst
  autocmd!
  autocmd FileType rst set spell
augroup END
" }}}
