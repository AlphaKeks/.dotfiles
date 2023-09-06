" indentation
set autoindent
set breakindent
set breakindentopt=shift:2,list:2
set cindent
set smartindent
set shiftwidth=4
set tabstop=4

" completion
set complete=.,w
set completeopt=menu,menuone
set pumheight=10
set wildchar=<c-n>
set wildmenu
set wildoptions=fuzzy,pum

" ui
set colorcolumn=101
set confirm
set cursorline
set cursorlineopt=screenline,number
set display=lastline
set fillchars=vert:│,fold:\ ,foldopen:,foldclose:,foldsep:\ 
set guicursor=a:block,v-r-cr-o:hor20,i:ver20,n-c-i:blinkwait300-blinkon200-blinkoff150
set history=1000
set laststatus=2
set list
set listchars=tab:│\ ,trail:-
set menuitems=10
set mouse=a
set number
set relativenumber
set ruler
set rulerformat=%{line('.')}:%{col('.')}
set scrolloff=10
set shortmess=inxsTI
set showcmd
set showcmdloc=statusline
set signcolumn=yes
set splitbelow
set splitright
set statusline=%!alphakeks#statusline()
set tabline=%!alphakeks#tabline()
set termguicolors
set wrap

" search
set hlsearch
set incsearch
set ignorecase
set smartcase
set wildignorecase

" formatting
set formatoptions=crqn1jp
set textwidth=100

" grep
set grepformat=%f:%l:%c:%m
set grepprg=rg\ --vimgrep\ -i

" automatically reload buffers when the underlying file changes.
set autoread

" allow backspacing over the start of lines.
set backspace=indent,eol,start

" fuck these features. Seriously.
set belloff=all
set noswapfile

" matching characters
set matchpairs+=<:>
set matchtime=69420
set showmatch

" folding
set foldmethod=indent
set foldtext=alphakeks#foldtext()
set foldlevel=99

" path
set path=.,**

" encoding
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

" undo history
set undodir=~/.vim/undo
set undofile

" netrw
let g:netrw_banner=0
let g:netrw_liststyle=1
let g:netrw_bufsettings='nonu rnu noconfirm'

" colorscheme
colorscheme dawn

" fzf
let g:fzf_layout = { 'window': { 'width': 1.0, 'height': 0.25, 'relative': v:true, 'yoffset': 1.0 } }
let g:fzf_colors = { 'fg': ['fg', 'Normal'], 'bg': ['bg', 'Normal'] }
