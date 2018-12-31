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
Plugin 'fholgado/minibufexpl.vim'
Plugin 'honza/vim-snippets'
Plugin 'jnurmine/Zenburn'
Plugin 'lifepillar/vim-mucomplete'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
"Plugin 'scrooloose/syntastic'
Plugin 'w0rp/ale'
Plugin 'SirVer/ultisnips'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sensible'
Plugin 'unblevable/quick-scope'
Plugin 'w0ng/vim-hybrid'

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
colorscheme hybrid

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

set laststatus=2 " Always display status line

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

"status line setup
set statusline=%f "tail of the filename

"display a warning if file format isn't Unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h "help file flag
set statusline+=%y "filetype
set statusline+=%r "read only flag
set statusline+=%m "modified flag

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%= "left/right separator
set statusline+=%{gutentags#statusline('[Generating...]')}
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c, "cursor column
set statusline+=%l/%L "cursor line/total lines
set statusline+=\ %P "percent through file

" Return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
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
  \ 'default' : ['path', 'ulti', 'omni', 'tags', 'keyn'],
  \ 'css'     : ['path', 'omni', 'keyn'],
  \ 'markdown': ['path', 'ulti', 'keyn', 'dict', 'uspl'],
  \ 'text'    : ['uspl', 'keyn'],
  \ 'vim'     : ['path', 'cmd', 'keyn']
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
" minibufexpl
" -----------------------------------------------------------------------------

nmap <silent> <Leader>b :MBEFocus<CR>
nmap <silent> <Leader>l :MBEbn<CR>
nmap <silent> <Leader>h :MBEbp<CR>

" -----------------------------------------------------------------------------
" NerdTree
" -----------------------------------------------------------------------------

nmap <silent> <Leader>p :NERDTreeToggle<CR>

" -----------------------------------------------------------------------------
" jedi-vim
" -----------------------------------------------------------------------------

" Let vim-mucomplete handle autocompletion
let g:jedi#popup_on_dot=0

" -----------------------------------------------------------------------------
" vim-dispatch
" -----------------------------------------------------------------------------

nnoremap <F9> :Dispatch<CR>

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
