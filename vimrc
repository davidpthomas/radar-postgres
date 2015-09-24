:hi Normal ctermbg=15

set fileencoding=latin1
set gfn=Monospace\ 10
"------------------------------------------------------------------------------
" Environment
"------------------------------------------------------------------------------
" folding by marker {{{,}}}
set foldmethod=marker

" height of command-line on bottom
set cmdheight=2

" don't behave like Vi
set nocompatible
" Minimal number of screen lines to keep above and below the cursor
set scrolloff=3
" Number of spaces to use for each step of (auto)indent
set shiftwidth=2
" Number of spaces that a <Tab> in the file counts for
set tabstop=2
" Copy indent from current line when starting new line
set autoindent
" Do smart autoindenting when starting a new line
set smartindent
" Show the line and column number of the cursor position
set ruler
" Title of the window will be set to the value of 'Vim - <filename>'
set title
" Don't wrap lines
set nowrap
" characters to show before wrapped lines
set showbreak=<<>>
" Syntax highlighting
syntax on
" expand tabs to spaces
set expandtab
" turn off error bells
set noerrorbells
" set visual bells to have no beep or flash
set vb t_vb=
" filetype detection
filetype on
" show mode (Insert, Replace, Visual)
set showmode
" print unprintable chars with '^'
set list
" Characters to show in list mode
" set listchars=tab:��,trail:�,eol:^,extends:>,precedes:<
set listchars=eol:^,extends:>,precedes:<
" set width of text line (max 80)
set textwidth=200
" show line numbers
set number
" set favorite color scheme
"colorscheme adaryn
"colorscheme darkblue
colorscheme default
"colorscheme delek
" colorscheme murphy
"colorscheme blue  " great for sunny days
" max number of undo levels
set undolevels=1000
" number of characters to be typed before swap file written to
set updatecount=100
" always show status line
set laststatus=2

autocmd BufNewFile,BufEnter *.py set sw=4 ts=4
"------------------------------------------------------------------------------
" Windows/Buffers
"------------------------------------------------------------------------------

" horiz split new windows below current
set splitbelow
" vert split new windows to right of current
set splitright
" make all windows equal size after splitting or closing a window
set equalalways
" minimum width (hard) for a window; keep small split windows visible
set winheight=3
" minimum height (hard) for a window; keep small split windows visible
set winminheight=3

" set color of window title when moving to new window
autocmd WinEnter * hi StatusLine ctermbg=LightBlue ctermfg=White
autocmd WinEnter * hi StatusLineNC ctermbg=LightGray ctermfg=Black

"------------------------------------------------------------------------------
" Searching
"------------------------------------------------------------------------------

" show matched pattern incrementally
set incsearch
" highlight all matches of previous search pattern
set hlsearch
" set substitutions to be 'global' by default
" ANNOYING set gdefault
" Show matching brackets
set showmatch
" searches wrap around end of file
set wrapscan

"------------------------------------------------------------------------------
" Misc
"------------------------------------------------------------------------------
" jump to last known position in file (saved in mark '"
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" in diff mode, scroll comparing windows at same time
if &diff
    set scrollbind
endif

" CTRL-A selects all in terminal vim and sets in clipboard
nmap <C-a> mzggVG"+y'z<CR>

