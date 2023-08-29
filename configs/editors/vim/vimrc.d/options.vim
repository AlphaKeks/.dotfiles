" Refresh buffers when the underlying file gets updated
set autoread

" Indentation
set autoindent
set breakindent
let &breakindentopt = "shift:" . &tabstop
set copyindent
set noexpandtab
set shiftwidth=4
set smartindent
set tabstop=4

" Allow backspacing at the start of lines
set backspace=indent,eol,start

" Do not ring le bell
set belloff=all

" Funny gray line
set colorcolumn=101

" Completion
set complete=.,w
set completeopt=menu,menuone,preview,noinsert,noselect
" TODO: set completepopup
set pumheight=10

" Delete multibyte characters one byte at a time
set delcombine

" Only hide the last 3 columns of the last line if it is too long
set display=lastline

" Folding
set nofoldenable
set foldlevelstart=99
set foldmethod=indent

" Grepping
set grepformat=%f:%l:%c:%m
set grepprg=rg\ --vimgrep\ -i

" Searches
set hlsearch
set ignorecase
set incsearch
set smartcase

" Character matching
set matchpairs+=<:>
set matchtime=69420
set showmatch

" Line numbers
set number
set numberwidth=3
set relativenumber

" Other settings
set confirm
set cursorline
set encoding=utf-8
set fileencoding=utf-8
set timeoutlen=500
set fillchars=vert:│,fold:\ ,foldopen:,foldclose:,foldsep:\ 
set formatoptions=crqn2lj
set guicursor=a:block,v-r-cr-o:hor20,i:ver20,n-c-i:blinkwait300-blinkon200-blinkoff150
set guifont=JetBrains\ Mono
set history=999
set iskeyword=a-z,A-Z,45,48-57,_,-
set laststatus=2
set list
set listchars=tab:│\ ,trail:-
set menuitems=10
set mousehide
set path=.,**
set previewheight=10
set ruler
set scrolloff=6
set shortmess=ilmnrwxost
set showcmd
set signcolumn=yes
set splitbelow
set splitright
set noswapfile
set tabline=%!alphakeks#tabline()
set termencoding=utf-8
set termguicolors
set textwidth=100
set tildeop
set undodir=~/.vim/undo
set undofile
set updatetime=50
set wildchar=<C-n>
set wildignorecase
set wildmenu
set wildoptions=fuzzy,pum
set wrap

" netrw
let g:netrw_banner=0
let g:netrw_liststyle=1
let g:netrw_bufsettings="nonu rnu noconfirm"

" Colorscheme
colorscheme dawn

" FZF
let g:fzf_layout = { "window": { "width": 1.0, "height": 0.25, "relative": v:true, "yoffset": 1.0 } }
let g:fzf_colors = { "fg": ["fg", "Normal"], "bg": ["bg", "Normal"] }
