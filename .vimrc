" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
set number

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Highlight cursor line underneath the cursor vertically.
set cursorcolumn

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Set encoding to utf-8
set encoding=utf-8

" Make backspace works
set backspace=indent,eol,start

" Use space characters instead of tabs.
"set expandtab

" Do not save backup files.
"set nobackup

" Do not let cursor scroll below or above N number of lines when scrolling.
"set scrolloff=10

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
"set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
"set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

"Set colorscheme to gruvbox8
set background=dark
colorscheme gruvbox8_hard

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Make :UltiSnipsEdit to split window.
let g:UltiSnipsEditSplit="vertical"

" Enable ALE autocompletion
let g:ale_completion_enabled=1

" Set okular as default viewer
let g:vimtex_view_method = 'zathura'

" Set clang-format codestyle
let g:clang_format#code_style = 'chromium'

" Allows local vimrc
set exrc


" PLUGINS ---------------------------------------------------------------- {{{

call plug#begin('~/.vim/plugged')

  Plug 'dense-analysis/ale'
  Plug 'preservim/nerdtree'
  Plug 'liuchengxu/vim-clap', {'do': ':Clap install-binary!'}
  Plug 'tomtom/tcomment_vim'
  Plug 'liuchengxu/vista.vim'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'tommcdo/vim-exchange'
  Plug 'tpope/vim-fugitive'
  Plug 'preservim/vim-pencil'
  Plug 'junegunn/fzf', {'do': {->fzf#install()}}
  Plug 'junegunn/fzf.vim'
  Plug 'lervag/vimtex'
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'neovimhaskell/haskell-vim'
  Plug 'alx741/vim-hindent'
  Plug 'sdiehl/vim-ormolu'
  Plug 'tikhomirov/vim-glsl'
  Plug 'github/copilot.vim'
  Plug 'rhysd/vim-clang-format'
  Plug 'whonore/Coqtail'

call plug#end()
" }}}
" MAPPINGS --------------------------------------------------------------- {{{

" Mappings code goes here.

" }}}
" VIMSCRIPT -------------------------------------------------------------- {{{

" Make Ag searches only inside file and not filenames by making it search only
" from the 4th :
" command! -bang -nargs=* Ag
" 	\ call fzf#vim#ag(<q-args>,
" 	\				  fzf#vim#with_preview(
" 	\ 				  {'options': '--delimiter : --nth 4..'},
" 	\				  'right:50%'),
" 	\				  <bang>0)

" Allows passing arguments to :Ag
function! s:ag_with_opts(arg, bang)
	let tokens = split(a:arg)
	let ag_opts = join(filter(copy(tokens), 'v:val =~ "^-"')).' --delimiter : --nth 4..'
	let dir = join(filter(copy(tokens), 'v:val =~ "^\/"'))
	let query = join(filter(copy(tokens), 'v:val !~ "^[-/]"'))
	let ag_args = fzf#vim#with_preview({'options': ag_opts},
				\					   'right:50%')
	let dir = substitute(dir,'^\/','','')
	let ag_args['dir'] = dir
	call fzf#vim#ag(query,
				\	ag_args,
				\	a:bang)
endfunction

autocmd VimEnter * command! -nargs=* -bang Ag
	\ call s:ag_with_opts(<q-args>, <bang>0)

" Enable the marker method of folding for vimscript
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

"Make ibus work with vim
function! IBusOff()
	" Lưu engine hiện tại
	let g:ibus_prev_engine = system('ibus engine')
	" Chuyển sang engine tiếng Anh
	" Nếu bạn thấy cái cờ ở đây
	" khả năng là font của bạn đang render emoji lung tung...
	" xkb : us :: eng (không có dấu cách)
	silent! execute '!ibus engine xkb:us::eng'
endfunction
function! IBusOn()
	let l:current_engine = system('ibus engine')
	" nếu engine được set trong normal mode thì
	" lúc vào insert mode duùn luôn engine đó
	if l:current_engine !~? 'xkb:us::eng'
		let g:ibus_prev_engine = l:current_engine
	endif
	" Khôi phục lại engine
	silent! execute '!ibus engine ' . g:ibus_prev_engine
endfunction
augroup IBusHandler
	" Khôi phục ibus engine khi tìm kiếm
	autocmd CmdLineEnter [/?] silent call IBusOn()
	autocmd CmdLineLeave [/?] silent call IBusOff()
	autocmd CmdLineEnter \? silent call IBusOn()
	autocmd CmdLineLeave \? silent call IBusOff()
	" Khôi phục ibus engine khi vào insert mode
	autocmd InsertEnter * silent call IBusOn()
	" Tắt ibus engine khi vào normal mode
	autocmd InsertLeave * silent call IBusOff()
augroup END
"Turn off ibus when enter vim
silent call IBusOff()

" Turn on PencilSoft
autocmd VimEnter * PencilSoft

" Enable the indent method of folding for Fortran
augroup filetype_f90
	autocmd!
	autocmd FileType fortran setlocal foldmethod=indent
	autocmd FileType fortran 
				\let g:ale_fortran_gcc_options="-Wall -fdefault-real-8 -fdefault-double-8 -Wextra -Wimplicit-interface -llapack -lrefblas"
augroup END

" Enable folding method for C++
augroup filetype_cpp
	autocmd!
	autocmd FileType cpp setlocal foldmethod=indent
augroup END
autocmd FileType cpp ClangFormatAutoEnable

" Enable folding method for LaTex
augroup filetype_tex
	autocmd!
	autocmd FileType tex setlocal foldmethod=indent
augroup END

" Enable syntax for Haskell
augroup filetype_hs
	autocmd!
	autocmd FileType haskell setlocal expandtab
	autocmd FileType haskell setlocal foldmethod=indent
	autocmd FileType haskell setlocal sw=2
augroup END

" If the current file type is HTML, set indentation to 2 spaces.
autocmd Filetype html setlocal tabstop=2 shiftwidth=2 expandtab

" If Vim version is equal to or greater than 7.3 enable undofile.
" This allows you to undo changes to a file even after saving it.
if version >= 703
    set undodir=~/.vim/backup
    set undofile
    set undoreload=10000
endif

" You can split a window into sections by typing `:split` or `:vsplit`.
" Display cursorline and cursorcolumn ONLY in active window.
augroup cursor_off
    autocmd!
    autocmd WinLeave * set nocursorline nocursorcolumn
    autocmd WinEnter * set cursorline cursorcolumn
augroup END

" If GUI version of Vim is running set these options.
if has('gui_running')

    " Set the background tone.
    set background=dark

    " Set the color scheme.
    colorscheme molokai

    " Set a custom font you have installed on your computer.
    " Syntax: set guifont=<font_name>\ <font_weight>\ <size>
    set guifont=Monospace\ Regular\ 12

    " Display more of the file by default.
    " Hide the toolbar.
    set guioptions-=T

    " Hide the the left-side scroll bar.
    set guioptions-=L

    " Hide the the right-side scroll bar.
    set guioptions-=r

    " Hide the the menu bar.
    set guioptions-=m

    " Hide the the bottom scroll bar.
    set guioptions-=b

    " Map the F4 key to toggle the menu, toolbar, and scroll bar.
    " <Bar> is the pipe character.
    " <CR> is the enter key.
    nnoremap <F4> :if &guioptions=~#'mTr'<Bar>
        \set guioptions-=mTr<Bar>
        \else<Bar>
        \set guioptions+=mTr<Bar>
        \endif<CR>

endif
" }}}
" STATUS LINE ------------------------------------------------------------ {{{

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2
" }}}
