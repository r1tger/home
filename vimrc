set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'elmcast/elm-vim'
Plugin 'honza/vim-snippets'
Plugin 'itchyny/lightline.vim'
Plugin 'kristijanhusak/vim-hybrid-material'
Plugin 'lervag/vimtex'
Plugin 'lifepillar/vim-mucomplete'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'majutsushi/tagbar'
Plugin 'maximbaz/lightline-ale'
Plugin 'mengelbrecht/lightline-bufferline'
Plugin 'scrooloose/nerdtree'
Plugin 'SirVer/ultisnips'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sensible'
Plugin 'unblevable/quick-scope'
Plugin 'w0rp/ale'
Plugin 'niklaas/lightline-gitdiff'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Brief help
"
" Install Vundle from GitHub:
"   git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" -----------------------------------------------------------------------------
" General
" -----------------------------------------------------------------------------

set encoding=utf8

" Enforce termincal has 256 colors
set t_Co=256

" Custom colour scheme
set background=dark
let g:enable_bold_font = 1
colorscheme hybrid_reverse

augroup vimrc
    autocmd!
    "Fix MatchParen colouring
    autocmd ColorScheme * hi! MatchParen guifg=#81a2be ctermfg=110 guibg=NONE ctermbg=NONE gui=NONE,bold cterm=NONE,bold term=NONE,bold
augroup END

" Window controls
noremap <C-h> <C-W>h
noremap <C-k> <C-W>k
noremap <C-l> <C-W>l
noremap <C-j> <C-W>j

" Remap parens to make paragraph navigation work with Space Cadet
nnoremap ( {
nnoremap ) }

syntax on
set hidden

" Display tabs and trailing spaces
set list
set listchars=eol:¶,tab:›-,trail:›,extends:›,precedes:‹

" Line options
set nowrap
set nu
set colorcolumn=80
set relativenumber
set cursorline
set tw=79

" Indent settings
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set autoindent

set showcmd  " Show incomplete cmds down the bottom
set showmode " Show current mode down the bottom

" Folding settings
set foldmethod=indent " Fold based on indent
set foldnestmax=3     " Deepest fold is 3 levels
set nofoldenable      " Don't fold by default

" Search options
set incsearch  " Find the next match as we type the search¶
set ignorecase " Ignore case when searching or substituting¶
set hlsearch   " Highlight searches by default¶

" Change leader key
let mapleader="\<Space>"

" Encrypt/decrypt files
command! -nargs=1 WriteEncrypted w !openssl enc -aes-256-cbc -a -salt -out <q-args>
command! Password r !openssl rand -base64 12

" Reload .vimrc when updated
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

" Format the current paragraph
nnoremap <Leader>f gqap

" Remap buffer switching
nmap <silent> <Leader>l :bn<CR>
nmap <silent> <Leader>h :bp<CR>

" -----------------------------------------------------------------------------
" Spelling
" -----------------------------------------------------------------------------

" Set spelling options
set spelllang=en_gb
nmap <silent> <Leader>s :set spell!<CR>
" Add a dictionary for text based files
autocmd FileType markdown,text setlocal complete+=k/usr/share/dict/words

" -----------------------------------------------------------------------------
" Status line
" -----------------------------------------------------------------------------

" Hide mode indicator
set noshowmode
" Always show tabline
set showtabline=2

" Refresh the statusline when GutenTags is done
augroup LightlineGutentags
    autocmd!
    autocmd User GutentagsUpdating call lightline#update()
    autocmd User GutentagsUpdated call lightline#update()
augroup END
autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()

" Lightline configuration
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'active': {
    \     'left': [ [ 'mode', 'paste' ],
    \               [ 'gitbranch', 'gitdiff', 'readonly', 'filename', 'modified',
    \                 'gutentag', 'tagbar' ], ],
    \     'right': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
    \              [ 'lineinfo' ], [ 'percent' ],
    \              [ 'highlight', 'fileformat', 'fileencoding', 'filetype' ], ],
    \ },
    \ 'tabline': {
    \     'left': [ [ 'buffers' ] ],
    \     'right': [ [ 'close' ] ],
    \ },
    \ 'component': {
    \     'tagbar': '%{tagbar#currenttag("%s", "No context", "f")}',
    \     'lineinfo': ' %3l:%-2v',
    \ },
    \ 'component_function': {
    \     'gitbranch': 'LightlineFugitive',
    \     'gitdiff': 'lightline#gitdiff#get',
    \     'highlight': 'LightlineCurrentHighlight',
    \     'gutentag': 'gutentags#statusline',
    \ },
    \ 'component_expand': {
    \     'buffers': 'lightline#bufferline#buffers',
    \     'linter_checking': 'lightline#ale#checking',
    \     'linter_warnings': 'lightline#ale#warnings',
    \     'linter_errors': 'lightline#ale#errors',
    \     'linter_ok': 'lightline#ale#ok',
    \ },
    \ 'component_type': {
    \     'buffers': 'tabsel',
    \     'linter_checking': 'left',
    \     'linter_warnings': 'warning',
    \     'linter_errors': 'error',
    \     'linter_ok': 'left',
    \     'gitdiff': 'middle',
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' },
    \ }

" Remove path from tabline filenames
let g:lightline#bufferline#filename_modifier = ':t'
" Set git diff display
let g:lightline#gitdiff#indicator_added = 'A:'
let g:lightline#gitdiff#indicator_deleted = 'D:'
let g:lightline#gitdiff#indicator_modified = 'M:'

function! LightlineFugitive()
    if exists('*fugitive#head')
        let branch = fugitive#head()
        return branch !=# '' ? ' '.branch : ''
    endif
    return ''
endfunction

" Return the syntax highlight group under the cursor ''
function! LightlineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return name
    endif
endfunction

" -----------------------------------------------------------------------------
" Elm.vim
" -----------------------------------------------------------------------------

let g:elm_setup_keybindings = 0
let g:elm_format_autosave = 0
let g:elm_detailed_complete = 1
let g:elm_format_fail_silently = 1

" -----------------------------------------------------------------------------
" ALE
" -----------------------------------------------------------------------------

let g:ale_sign_column_always = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" -----------------------------------------------------------------------------
" Syntastic
" -----------------------------------------------------------------------------

let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0

" -----------------------------------------------------------------------------
" vim-mucomplete
" -----------------------------------------------------------------------------

" Required completion options
set completeopt-=preview
set completeopt+=menuone,noinsert,noselect " Don't add 'longest', breaks dict

" Enable at startup
let g:mucomplete#enable_auto_at_startup = 1

let g:mucomplete#chains = {
  \ 'default' : ['path', 'ulti', 'omni', 'tags', 'incl'],
  \ 'css'     : ['path', 'omni', 'incl'],
  \ 'markdown': ['path', 'ulti', 'incl', 'dict', 'uspl'],
  \ 'text'     : ['path', 'ulti', 'incl'],
  \ 'tex'     : ['path', 'ulti', 'incl'],
  \ 'vim'     : ['path', 'cmd', 'tags', 'keyn']
  \ }

" -----------------------------------------------------------------------------
" UltiSnips
" -----------------------------------------------------------------------------

" Remap trigger to <CR> to allow selection mucomplete list
let g:UltiSnipsExpandTrigger='<C-e>'
let g:UltiSnipsJumpForwardTrigger='<Tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'

" -----------------------------------------------------------------------------
" vim-gutentags
" -----------------------------------------------------------------------------

let g:gutentags_cache_dir="~/.vim/cache"
let g:gutentags_project_root=['pip-selfcheck.json'] " enable for virtualenv

" -----------------------------------------------------------------------------
" vim-tagbar
" -----------------------------------------------------------------------------

nmap <silent> <Leader>t :TagbarToggle<CR>

" -----------------------------------------------------------------------------
" NerdTree
" -----------------------------------------------------------------------------

nmap <silent> <Leader>p :NERDTreeToggle<CR>

" -----------------------------------------------------------------------------
" jedi-vim
" -----------------------------------------------------------------------------

" Let vim-mucomplete handle autocompletion
let g:jedi#popup_on_dot=1

" -----------------------------------------------------------------------------
" vim-dispatch
" -----------------------------------------------------------------------------

nnoremap <F9> :Dispatch!<CR>

" -----------------------------------------------------------------------------
" Strip whitespace on save
" -----------------------------------------------------------------------------

autocmd BufWritePre * call <SID>StripTrailingWhitespace()
function! <SID>StripTrailingWhitespace()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunction

" -----------------------------------------------------------------------------
" Restore cursor position on file open
" -----------------------------------------------------------------------------

autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal g`\""
        endif
    end
endfunction
