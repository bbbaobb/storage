set nocompatible
set foldmethod=marker
set scrolloff=5       " set so

set timeoutlen=50

"if filereadable(expand("<path>"))
"    source <path>
"endif
"runtime! vimrc.plug        "toooooo slow

"cursor location
set number
set relativenumber
set ruler
nnoremap <F2> :set nonumber!<CR>:set nornu!<CR>

"syntax and color
filetype plugin on
filetype indent on
syntax enable
syntax on
set autoindent

"set t_Co=256
set termguicolors          "ugly color
"set background=dark
"colorscheme ron
colorscheme desert
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText guibg=NONE ctermbg=NONE

set smartindent		"set si
set backspace=indent,eol,start	"eol
set ignorecase
set nohlsearch			"don't highlight the search results
set incsearch			" do incremental searching增量搜索
set nowrap			"no auto-wrap,necessary for coding

"{{{ tab and space
set tabstop=4		"enable tab
set expandtab
set shiftwidth=4
set softtabstop=4
nnoremap <F3> :set noexpandtab!<CR>
nnoremap <F4> :set expandtab!<CR>
"}}}

scriptencoding utf-8
set encoding=utf-8
"{{{ highlight tabs and spaces
set list " show particular symbols
set listchars=tab:›\ ,trail:•,extends:#,precedes:<,nbsp:.
"}}}

set cursorline
set cursorcolumn

" make vim copy from the system clipboard
set go+=a
set mouse=a

map<Backspace> <Nop>
"noremap <Up> <Nop>
"noremap <Right> <Nop>
"noremap <c-z> <NOP>
"inoremap <Up> <NOP>

"nnoremap <C-F5> <Esc>:w<CR>:!g++ -std=c++11 % -o /tmp/a.out && /tmp/a.out<CR>
"map <F3> :NERDTreeToggle<CR>

set pastetoggle=<F9>

set showcmd
set showmode
set showmatch


"set completeopt+=longest	"让Vim的补全菜单行为与一般IDE一致
