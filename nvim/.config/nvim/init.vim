" Leader
let mapleader = "\<space>"

" Auto install plug if not found
if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config//nvim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')

" Hide view ui
Plug 'junegunn/goyo.vim'

" Colorscheme
Plug 'colorschemes/synthwave'

" Async lint
Plug 'benekastah/neomake'
    let g:neomake_open_list = 1
    let g:neomake_place_signs = 1
    let g:neomake_error_sign = {
        \ 'text': 'E>',
        \ 'texthl': 'Error',
    \ }
    let g:neomake_warning_sign = {
        \ 'text': 'W>',
        \ 'texthl': 'TermCursorNC',
    \ }

" Clicking v expands region
Plug 'kana/vim-textobj-user'
\| Plug 'kana/vim-textobj-line'
\| Plug 'terryma/vim-expand-region'
	vmap v <Plug>(expand_region_expand)
	vmap <C-v> <Plug>(expand_region_shrink)

Plug 'terryma/vim-multiple-cursors'
	let g:multi_cursor_use_default_mapping = 0
	let g:multi_cursor_next_key='<C-j>'
	let g:multi_cursor_prev_key='<C-k>'
	let g:multi_cursor_skip_key='<C-l>'
	let g:multi_cursor_quit_key='<Esc>'

" Shows search results as you're typing
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-oblique'
	let g:oblique#incsearch_highlight_all = 1
	let g:oblique#clear_highlight = 1
	let g:oblique#prefix = "\\v" " Very Magic

Plug 'tpope/vim-commentary'
Plug 'rstacruz/vim-closer'
Plug 'tpope/vim-surround'
	" Maps ss to surround word
	nmap ss ysiw

	" Maps sl to surround line
	nmap sl yss

	" Surround Visual selection
	vmap s S

" Filetype Plugins
Plug 'JulesWang/css.vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'othree/html5.vim'
Plug 'kchmck/vim-coffee-script'

call plug#end()

" }}}

" Filetypes {{{

filetype plugin indent on

augroup Filetypes
	au!

	" All Filetypes
	" Disable comment on newline
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

	" Remove Whitespace on save
	autocmd BufWritePre * :%s/\s\+$//e

    " Run neomake on every save of fetch
    " autocmd BufWritePost *.sh,fetch Neomake

	" Clear cmdline on bufread/enter
	autocmd BufEnter,BufReadPost,BufWinEnter,CmdwinEnter,CmdwinLeave * redraw!

	" Html
	" Map </ to auto close tags
	autocmd FileType html inoremap <buffer> </ </<C-X><C-O>

	" Markdown
	" set .md files to filetype markdown
	autocmd BufNewFile,BufRead *.md set filetype=markdown

	" Equalize splits on resize, mainly used with Goyo to fix it's padding on resize.
	autocmd VimResized * execute "normal \<C-W>="

    " Always use goyo
    autocmd BufRead * Goyo 95%x95%

        " Plugins
    autocmd FileType xdefaults setlocal commentstring=!\ %s
    autocmd FileType scss setlocal commentstring=/*%s*/

    " Set rtorrent config to zsh filetype to fix syntax highlighting
	autocmd BufRead .rtorrent.rc set filetype=markdown
augroup END

" }}}

" Spaces and Tabs {{{

" Set indent to 4 spaces wide
set tabstop=4
set shiftwidth=4

" A combination of spaces and tabs are used to simulate tab stops at a width
set softtabstop=4
set expandtab

" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_

" }}}

" Line Wrap {{{

" Soft wraps lines without editing file
set wrap

" Stops words from being cut off during linebreak
set linebreak

" Set textwidth to 80 characters
set textwidth=0
set nolist
set wrapmargin=0

" Copy indent from previous line on linebreak
set autoindent

" Linebreaks keep indent level
set breakindent

" }}}

" Look and Feel {{{

" Colorscheme
colorscheme synthwave

" Enable true color for neovim
let $NVIM_TUI_ENABLE_TRUE_COLOR = 1

" Enables cursor similar to gui programs
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

" Change window title to filename
set title

" Turn off linenumbers
set nonumber

" Hide ruler
set noruler

" Don't redraw screen as often
set lazyredraw

" Limit syntax highlighting length
set synmaxcol=1000

" Don’t show the intro message when starting Vim
set shortmess=atI

" Hide mode indicator
set noshowmode

" Always show statusline
set laststatus=2

" }}}

" Searching {{{

" Highlight search matches
set hlsearch

" Show search results as you type
set incsearch

" Ignore case in searches if query doesn't include capitals
set ignorecase
set smartcase

" }}}

" Mapping {{{

" Unmap space in normal and visual modes
nnoremap <SPACE> <nop>
vnoremap <SPACE> <nop>

" Map ctrl c to escape to fix multiple cursors issue
noremap <C-c> <Esc>

" Map the capital equivalent for easier save/exit
cabbrev Wq wq
cabbrev W w
cabbrev Q q

" Map q to qa to quickly exit when using goyo
cnoreabbrev q qa

" unmap capital K
nnoremap K <nop>

" Copies what was just pasted
" Allows you to paste the same thing over and over and over and over and over and over
xnoremap p pgvy

" Cylces through splits using a double press of enter in normal mode
nmap <CR><CR> <C-w><C-w>

" Map ; to :
noremap ; :

" Save files with root privliges
cmap w!! w !sudo tee % >/dev/null

" Terminal Splits
cmap Hterm sp <bar> terminal
cmap Vterm vsp <bar> terminal

" Maps Tab to indent blocks of text in visual mode
vmap <TAB> >gv
vmap <BS> <gv
vmap <S-TAB> <gv

" Easily move to start/end of line
nnoremap H 0
vnoremap H 0
vnoremap L $

" unmap a in normal mode
nmap a <nop>

" za/az toggle folds
" ezpz to spam open/close folds now
nmap az za

" Shows the highlight group of whatever's under the cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

nmap <F1> :set number!<CR>
nmap <silent> <F2> :call Chmox() <CR>

" Temp Files {{{

" Fuck swapfiles
set noswapfile

" Set backup/undo dirs
set backupdir=~/.config/nvim/tmp/backups//
set undodir=~/.config/nvim/tmp/undo//

" Make the folders automatically if they don't already exist.
if !isdirectory(expand(&backupdir))
	call mkdir(expand(&backupdir), "p")
endif

if !isdirectory(expand(&undodir))
	call mkdir(expand(&undodir), "p")
endif

" Persistent Undo, Vim remembers everything even after the file is closed.
set undofile
set undolevels=500
set undoreload=500

" }}}

" Misc {{{

" Improve Neovim startup time by disabling python and host check
let g:python_host_skip_check= 1
let g:loaded_python_provider = 1
let g:loaded_python3_provider = 1

" Auto change dir to file directory
set autochdir

" Use the OS clipboard by default
set clipboard=unnamedplus

" Dictionary
set dictionary=/usr/share/dict/words

" Enhance command-line completion
set wildmenu
set wildmode=longest,full
set wildignore+=*/.hg/*,*/.git/*,*/.svn/*
set wildignore+=*.gif,*.png,*.jp*
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildignore+=*/.sass-cache/*,*.map

" Saner backspacing
set backspace=indent,eol,start

set esckeys
set noeol
set showcmd
set autoread
set hidden
set noerrorbells

" Don’t reset cursor to start of line when moving around.
set nostartofline

" Better auto complete
set complete=.,w,b,u,t,i
set completeopt=longest,menu,preview

set nrformats-=octal
set notimeout
set nottimeout

" More natural split opening
set splitbelow
set splitright

" }}}

" Folding {{{

set foldmethod=marker
set foldlevel=99
set foldlevelstart=0
set foldnestmax=10

" Only saves folds/cursor pos in mkview
set viewoptions=folds,cursor

set fillchars=fold:-

" }}}

" Functions {{{

" Better Buffer Navigation {{{
" Maps <Tab> to cycle though buffers but only if they're modifiable.
" If they're unmodifiable it maps <Tab> to cycle through splits.

function! BetterBufferNav(bcmd)
	if &modifiable == 1 || &ft == 'help'
		execute a:bcmd
		call PersistentEcho(" ")
	else
		wincmd w
	endif
endfunction

" Maps Tab and Shift Tab to cycle through buffers
nmap <silent> <Tab> :call BetterBufferNav("bn") <Cr>
nmap <silent> <S-Tab> :call BetterBufferNav("bp") <Cr>

" }}}

" Quick Terminal {{{
" Spawns a terminal in a small split for quick typing of commands
" Also maps <Esc> to quit out of the terminal

function QuitTerminal()
	setlocal buflisted
	silent! bd! quickterm
	silent! bd! term://*//*/home/dyl/.fzf/bin/fzf*
endfunction

function! QuickTerminal()
	10new
	terminal
	file quickterm
endfunction

tnoremap <silent> <Esc> <C-\><C-n>:call QuitTerminal()<CR>
nnoremap <silent> <Leader>t :call QuickTerminal()<CR>

" }}}

" Fullscreen Help {{{
" Opens Help files as if any other file was opened with "e file"
" also works with completion like regular :help

" This works by opening a blank buffer and setting it's buffer type to 'help'. Now when you run 'help ...' the blank buffer will show the helpfile in fullscreen. The function then adds the buffer to the bufferlist so you can use :bn, :bp, etc.
function FullScreenHelp(helpfile)
	enew
	set bt=help
	execute "help " . a:helpfile
	set buflisted
endfunction

" Open help files the same as you usually do with "help example" and they'll open in a new buffer similar to "e file"
command -nargs=1 -complete=help Help call FullScreenHelp(<f-args>)
cabbrev help Help
cabbrev h Help

" }}}

" Line Return {{{
" Returns you to your position on file reopen and closes all folds.
" On fold open your cursor is on the line you were at on the fold.
augroup line_return
	au!
	autocmd BufReadPost * :call LineReturn()
augroup END

function! LineReturn()
	if line("'\"") > 0 && line("'\"") <= line("$")
		execute 'normal! g`"zvzzzm'
	endif
endfunction

" }}}

" Smart :bd {{{
" If more than 1 buffer exists close current buffer while retaining splits.
" bangs(!) are supported as well as arguments after :bd (:bd index.html, etc)
function SmartBD(bang, argu)
		if a:bang == 1
			let bang = "!"
		else
			let bang = " "
		endif

		if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
			execute "bd" . bang . " " . a:argu
		else
			bp
			execute "bd" . bang . " #"
		endif

endfunction

command! -bang -nargs=* BD call SmartBD(<bang>0, <q-args>)
cnoreabbrev bd BD

" }}}

" Persistent Echo {{{
" Keeps echo on screen, mainly used by me in other functions to clear the cmdline

func! PersistentEcho(msg)
	echo a:msg
	let g:PersistentEcho=a:msg
endfun

let g:PersistentEcho=''

if &ut>200|let &ut=0|endif

augroup Echo
	au CursorHold * if PersistentEcho!=''|echo PersistentEcho|let PersistentEcho=''|endif
augroup END

" }}}

" Custom message on save {{{

function SaveRO(bang, argu)
	if a:bang == 1
		let bang = "!"
	else
		let bang = " "
	endif

	if &readonly
		w !sudo tee % >/dev/null
		redraw
		call PersistentEcho("saved readonly file")
	else
		execute "w" . bang . " " . a:argu
		redraw
		call PersistentEcho("saved")
	endif
endfunction


command! -bang -nargs=* W call SaveRO(<bang>0, <q-args>)
cnoreabbrev w W

" }}}

" Open current file with another program {{{

function! Openwith(program)
	silent! execute "!" . a:program . " " . expand('%:p') . " &"
endfunction

command! -bang -nargs=* Openwith call Openwith(<q-args>)

" }}}

" Chmod +x current file {{{

function! Chmox()
	execute "!chmod +x " . expand('%:p')
endfunction

command! Chmox call Chmox()

" }}}

" }}}
