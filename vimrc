" ---------------------------------------------------------------------------
" Global setup
" ---------------------------------------------------------------------------
" Vim 8 defaults
unlet! skip_defaults_vim
silent! source $VIMRUNTIME/defaults.vim

augroup vimrc
  autocmd!
augroup END

let s:darwin = has('mac')
let s:windows = has('win32') || has('win64')
let s:python3_support = has('python3')
let mapleader = '\'
let maplocalleader = '\'


" ---------------------------------------------------------------------------
" plugin manager
" ---------------------------------------------------------------------------
" install package in path, begin(path)
silent! if plug#begin('~/.vim/plugged')

" ---------------------------------------------------------------------------
" plugin - face
" ---------------------------------------------------------------------------
" colorscheme
Plug 'morhetz/gruvbox'
"Plug 'pgavlin/pulumi.vim'

" ---------------------------------------------------------------------------
" plugin - vim utility
" ---------------------------------------------------------------------------
Plug 'tpope/vim-repeat'

" ---------------------------------------------------------------------------
" plugin - editting
" ---------------------------------------------------------------------------
" make JSDoc format commenting
Plug 'heavenshell/vim-jsdoc'
  " enable es6 arrow function for jsdoc
  let g:jsdoc_enable_es6 = 1
  " allow promt for interative input
  let g:jsdoc_allow_input_prompt = 1
  " promt for function description
  let g:jsdoc_input_description = 1
  " set param description seperator
  let g:jsdoc_param_description_seperator = ' '

" word surrounding utility like something to 'something' or <p>something</p>
Plug 'tpope/vim-surround'

" ---------------------------------------------------------------------------
" plugin - browsing
" ---------------------------------------------------------------------------
" draw indent line
Plug 'Yggdroot/indentLine'
  let g:indentLine_enabled = 1
  let g:indentLine_char_list = ['|', '¦', '┆', '┊']
  let g:indentLine_color_term = 239
  let g:indentLine_color_gui = '#616161'

"Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesEnable' }
"  autocmd! User indentLine doautocmd indentLine Syntax

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  augroup nerd_loader
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd BufEnter,BufNew *
          \  if isdirectory(expand('<amatch>'))
          \|   call plug#load('nerdtree')
          \|   execute 'autocmd! nerd_loader'
          \| endif
  augroup END

Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
  let g:tagbar_sort = 0

" bind gnu-grep for using grep fgrep egrep ...
Plug 'vim-scripts/grep.vim'
  " skip files when use 'Rgrep'
  let g:Grep_Skip_Files = '*~ tags cscope.out'
  let g:Grep_OpenQuickfixWindow = 1
  let g:Grep_Default_Options = '-rn'

" make bottom status bar readable by more functionality
Plug 'vim-airline/vim-airline'
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#formatter = 'unique_tail'

  let g:airline#extensions#ale#enabled = 1
  " setup powerline font
  " 1. install powerline font package
  " 2. apt-get install fonts-powerline
  " and then unicode will be applied
  " for getting interface looks good, install source-code-pro font
  " tip) must install source-code-pro font
  let g:airline_powerline_fonts = 1
  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  " unicode symbols
  let g:airline_left_sep = '»'
  let g:airline_left_sep = '▶'
  let g:airline_right_sep = '«'
  let g:airline_right_sep = '◀'
  let g:airline_symbols.linenr = '␊'
  let g:airline_symbols.linenr = '␤'
  let g:airline_symbols.linenr = '¶'
  let g:airline_symbols.branch = '⎇'
  let g:airline_symbols.paste = 'ρ'
  let g:airline_symbols.paste = 'Þ'
  let g:airline_symbols.paste = '∥'
  let g:airline_symbols.whitespace = 'Ξ'
  " airline symbols
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''
  let g:airline_theme = 'powerlineish'

Plug 'vim-airline/vim-airline-themes'

" ---------------------------------------------------------------------------
" plugin - git
" ---------------------------------------------------------------------------
" show if code is change, modified, delete in side of number line
Plug 'airblade/vim-gitgutter'
" show block range diff
Plug 'AndrewRadev/linediff.vim'
" git sytax highlight with snippet
Plug 'gisphm/vim-gitignore'
" use git command in vim
"Plug 'tpope/vim-fugitive'
"  nmap     <Leader>g :Gstatus<CR>gg<c-n>
"  nnoremap <Leader>d :Gdiff<CR>

" ---------------------------------------------------------------------------
" plugin - language
" ---------------------------------------------------------------------------
" python syntax highlighting
Plug 'vim-python/python-syntax'
  let g:python_highlight_func_calls = 1
  let g:python_highlight_builtins = 1
  let g:python_highlight_class_vars = 1
  let g:python_highlight_doctests = 1
  let g:python_highlight_indent_errors = 1
  let g:python_highlight_space_errors = 1

" provide improved javascript syntax highlight and indent
" This comment is left for historic point with vim-jxs-improve
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'othree/html5.vim'
" Jenkinsfile groovy syntax
Plug 'martinda/Jenkinsfile-vim-syntax'
if v:version >= 800
  " go all-in-one
  Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
    " use go error list with quickfix, not location list
    " see https://github.com/fatih/vim-go-tutorial#vimrc-improvements
    let g:go_list_type = "quickfix"
    " auto meta-linting
    "let g:go_metalinter_autosave = 1
    "let g:go_metalinter_deadline = "5s"
    " auto import
    let g:go_fmt_command = "goimports"
    " turn on the highlight
    let g:go_highlight_types = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_function_calls = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_extra_types = 1
endif
Plug 'honza/dockerfile.vim'
" kotlin - syntax highlight, indent, syntastic support
Plug 'udalov/kotlin-vim'
Plug 'evanleck/vim-svelte', {'branch': 'main'}

if v:version >= 800 && !s:windows
  " complete engine & lsp server management
  Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install() }}
endif

" LSP Client + Linter & Fixer
Plug 'dense-analysis/ale'
  let g:ale_fixers = {
        \'*': ['remove_trailing_lines', 'trim_whitespace'],
        \'javascript': ['prettier', 'eslint'],
        \'typescript': ['prettier', 'eslint'],
        \'python': ['black']
        \}
  let g:ale_linters = {
        \'javascript': ['eslint'],
        \'typescript': ['eslint'],
        \'python': ['flake', 'pylint']
        \}
  " use quickfix, not loclist
  let g:ale_set_loclist = 0
  let g:ale_set_quickfix = 1
  let g:ale_list_window_size = 5
  " set this variable to 1 to fix files when you save them.
  let g:ale_fix_on_save = 1
  let g:ale_lint_delay = 1000
  " set linter error, warning message format
  let g:ale_echo_msg_error_str = 'E'
  let g:ale_echo_msg_warning_str = 'W'
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  nmap ]a <Plug>(ale_next_wrap)
  nmap [a <Plug>(ale_previous_wrap)

" ---------------------------------------------------------------------------
" plugin - AI
" ---------------------------------------------------------------------------
" claude code
if has("nvim")
  Plug 'nvim-lua/plenary.nvim'
  Plug 'greggh/claude-code.nvim'
endif

" ---------------------------------------------------------------------------
" plugin - workflow
" ---------------------------------------------------------------------------
" snippet management
if v:version >= 704 && s:python3_support
  Plug 'SirVer/ultisnips'
    " Trigger configuration. if you use <Tab>, then it can be occur error with conflicting exist plugin using <Tab>.
    let g:UltiSnipsExpandTrigger="<Tab>"
    let g:UltiSnipsJumpForwardTrigger="<Right>"
    let g:UltiSnipsJumpBackwardTrigger="<Left>"
    let g:UltiSnipsEditSplit="vertical"     " If you want :UltiSnipsEdit to split your window.
    let g:UltiSnipsSnippetDirectories = ['~/.vim/snippet']
endif

" live markdown plugin
Plug 'shime/vim-livedown'

" tmux integration
Plug 'christoomey/vim-tmux-navigator'
  let g:tmux_navigator_no_mappings = 1
  " Write current buffers before navigating from Vim to tmux pane
  let g:tmux_navigator_save_on_switch = 1

" gdb integration
"Plug 'vim-scripts/Conque-GDB'
"  " 1: strip color after 200 line, 2: always with color
"  let g:ConqueTerm_Color=2
"  " close conque when program ends running
"  let g:ConqueTerm_CloseOnEnd=1
"  " display warning message if conqueTerm is configed incorrect
"  let g:ConqueTerm_StartMessages=0

call plug#end()
endif
" http://vimdoc.sourceforge.net/htmldoc/filetype.html#filetypes
filetype plugin indent on


" ---------------------------------------------------------------------------
" built-in settings
" ---------------------------------------------------------------------------
if s:darwin
  set clipboard=unnamed
else
  set clipboard=unnamedplus " linux
endif
" for include-search
set path+=.,/usr/include/*,/usr/include/**/*,**

" do not act like vi
set nocompatible

" Display number of line in side of editor (same with nu)
set number

" show current cursor coordination(row, col)
set ruler

" highlight paren pair
set showmatch

" viminfo size
set history=1000

" highlighting search
set hlsearch

" incremental search when insert characters one by one
set incsearch

" set cindent " c-lang auto indent on

" do auto indenting when starting a new line
set autoindent
set smartindent

" number of spaces to use for each step of (auto)indent
set shiftwidth=2

" https://vi.stackexchange.com/questions/24925/usage-of-timeoutlen-and-ttimeoutlen
set timeoutlen=500

" Stop the search at the end or start of the file
" that is, disabled search by rotating
set nowrapscan

" Write the contents of the fileon :make like command
" if it has been modified,
set autowrite

" Set column limit and its color
set colorcolumn=80

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649(CoC).
set nobackup
set nowritebackup

" not creating swap files
set noswapfile

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" set nopaste

" 'syntax on' allow you to change highlight color
syntax on
" set global colorscheme
autocmd vimenter * ++nested colorscheme gruvbox
"colorscheme pulumi
hi ColorColumn ctermbg=Red guibg=Red

" add filetypes
autocmd BufRead,BufNewFile *.yaml setfiletype general
autocmd BufRead,BufNewFile *.yml setfiletype general
autocmd BufRead,BufNewFile *.json setfiletype general
autocmd BufRead,BufNewFile *.cu setfiletype cuda
autocmd BufRead,BufNewFile *.kt setfiletype kotlin

" indent binding according to file type
" Note that vim augroup need, cuz it duplicate when sourcing init.vim file
" and duplicating make vim slow
augroup customIndent
    autocmd! customIndent
    autocmd FileType c set tabstop=4|set shiftwidth=4|set expandtab
    autocmd FileType javascript set tabstop=2|set shiftwidth=2|set expandtab
    autocmd FileType vim set tabstop=2|set shiftwidth=2|set expandtab
    autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
augroup END



" ---------------------------------------------------------------------------
" coc.nvim
" ---------------------------------------------------------------------------
if has_key(g:plugs, 'coc.nvim')
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) >= 0)
      execute 'h' expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  nnoremap <silent> K :call <SID>show_documentation()<CR>

  let g:coc_global_extensions = ['coc-git', 'coc-kotlin', 'coc-ultisnips',
    \ 'coc-r-lsp', 'coc-pyright', 'coc-html', 'coc-json', 'coc-css', 'coc-html',
    \ 'coc-prettier', 'coc-eslint', 'coc-tsserver', 'coc-emoji', 'coc-java', 'coc-deno']
  command! -nargs=0 Prettier :CocCommand prettier.formatFile

  let g:go_doc_keywordprg_enabled = 0

  augroup coc-config
    autocmd!
    autocmd VimEnter * nmap <silent> <leader>gd <Plug>(coc-definition)
    autocmd VimEnter * nmap <silent> <leader>gi <Plug>(coc-implementation)
    autocmd VimEnter * nmap <silent> <leader>su <Plug>(coc-references)
  augroup END
endif


" ---------------------------------------------------------------------------
" claude code
" ---------------------------------------------------------------------------
" config ref: https://github.com/greggh/claude-code.nvim?tab=readme-ov-file#configuration
if has("nvim")
lua << EOF
local ok, cc = pcall(require, 'claude-code')
if ok and cc and type(cc.setup) == 'function' then
  cc.setup({
    refresh={
      enable = true,
      updatetime = 100,
      timer_interval = 1000,
      show_notifications = true,
    }
  })
else
  vim.notify("claude-code not loaded: setup skipped", vim.log.levels.WARN)
end
EOF
endif


" ---------------------------------------------------------------------------
" my scripts
" ---------------------------------------------------------------------------
" Save to playground vim file
function! SaveToPlayground(prefix)
  call inputsave()
  let filename = input('Enter playground filename: ')
  call inputrestore()

  " https://stackoverflow.com/questions/28651472/in-vim-how-can-i-save-a-file-to-a-path-stored-in-a-variable
  let file = a:prefix.filename.".vim"
  exec "write ".file
endfunction

" clear without deleting line
function! ClearLine()
  normal! 0D
endfunction

" {{{ }}} 열고 닫는거 만들기
function! WrapWithStr(start, end)
  normal! {
  if getline(".") != ""
    normal! O
    call ClearLine()
  endif
  call setline(".", a:start)

  normal! }
  if getline(".") != ""
    normal! o
    call ClearLine()
  endif
  call setline(".", a:end)
endfunction

" Vimscript 정리를 위한 title comment wrapper
function! WrapVimTitle(start, end)
  " 글자 수에서 고정으로 변경
  let length = 75 " len(getline("."))

  if length == 0
    return <Esc>
  endif

  let start_comment = "\" "
  let l:str_wrapper = start_comment . repeat(a:start, length)
  let l:end_wrapper = start_comment . repeat(a:end, length)

  " 기존에 mapping되어있는 keybinding을 무시하고 normal모드 진입
  " 타이틀 위쪽에 {str_wrapper}를 삽입
  normal! O
  call setline(".", l:str_wrapper)

  " 타이틀 아래쪽에 {end_wrapper}를 삽입
  normal! jo
  call setline(".", l:end_wrapper)
endfunction


" ---------------------------------------------------------------------------
" Keybindings - built-in
" ---------------------------------------------------------------------------
" Force not to use arrow key in insert mode
inoremap <Left> <nop>
inoremap <Up> <nop>
inoremap <Right> <nop>
inoremap <Down> <nop>

" Force to use jk instead of <Esc> in insert mode
inoremap jk <Esc>
inoremap kj <Esc>

" Quickfix window commands
nnoremap <C-n> :cnext<CR>
nnoremap <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" Navigate split window quickly
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Reload current vim script
nnoremap <F5> :source %<cr>

" ---------------------------------------------------------------------------
" Keybindings - plugins
" ---------------------------------------------------------------------------
" binding :jsdoc key, generate JSdoc in front of function
nnoremap <silent> <C-l> <Plug>(jsdoc)
" Open markdown preview
nnoremap gm :LivedownToggle<CR>
" Grep pattern
nnoremap <silent> <F9> :Rgrep<CR>
" Open tagbar window
nnoremap <F8> :TagbarToggle<CR>
" Open nerdtree browsing window
nnoremap <Leader>nt <ESC>:NERDTreeToggle<CR>

" vim-go shortcuts
autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nnoremap <leader>t :GoTest -v<CR>
autocmd FileType go nnoremap <leader>c :GoErrCheck ./...<CR>

" vim-tmux-navigator shortcuts
nnoremap <silent> <C-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
" nnoremap <silent> {Previous-Mapping} :TmuxNavigatePrevious<cr>

" ---------------------------------------------------------------------------
" Keybindings - my script
" ---------------------------------------------------------------------------
" Save to playground vim file
nnoremap <leader>vim :call SaveToPlayground("~/.vim/playground/")<cr>
" wrapping vim comment title
nnoremap <leader>wv :call WrapVimTitle("-", "-")<CR>
" Open init.vim
nnoremap <leader>init :sp ~/.vimrc<cr>

" ---------------------------------------------------------------------------
" Keybindings - temp mapping
" ---------------------------------------------------------------------------
" line split for oneline - in visible mode
vnoremap <leader>t1 :s/\s-/\r-/g<CR>
