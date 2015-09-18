" vim:set ft=vim et tw=78 sw=2:

if $SOURCE_DIR == ''
  let $SOURCE_DIR = substitute(system("bash -i -c 'echo \"$SOURCE_DIR\"'"),'\n$','','')
endif
if $SOURCE_DIR == ''
  let $SOURCE_DIR = expand('~/src')
endif

function! s:SComplete(A,L,P)
  let match = split(glob($SOURCE_DIR.'/'.a:A.'*'),"\n")
  return map(match,'v:val[strlen($SOURCE_DIR)+1 : -1]')
endfunction
command! -bar -nargs=1 Scommand :command! -bar -bang -nargs=1 -complete=customlist,s:SComplete S<args> :<args><lt>bang> $SOURCE_DIR/<lt>args>

Scommand cd
Scommand lcd
Scommand read
Scommand edit
Scommand split
Scommand saveas
Scommand tabedit

command! -bar -range=% Trim :<line1>,<line2>s/\s\+$//e
command! -bar -range=% NotRocket :<line1>,<line2>s/:\@<!:\(\w\+\)\s*=>/\1:/ge

function! XTry(function, ...)
  if exists('*'.a:function)
    return call(a:function, a:000)
  else
    return ''
  endif
endfunction

set autoindent
set autoread
set backspace=indent,eol,start
set complete-=i      " Searching includes can be slow
set display=lastline " When lines are cropped at the screen bottom, show as much as possible
if &grepprg ==# 'grep -n $* /dev/null'
  set grepprg=grep\ -rnH\ --exclude='.*.swp'\ --exclude='*~'\ --exclude='*.log'\ --exclude=tags\ $*\ /dev/null
endif
set incsearch
set laststatus=2    " Always show status line
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
set list            " show trailing whitespace and tabs
set modelines=5
set scrolloff=1
set sidescrolloff=5
set showcmd
set showmatch
set smarttab
if &statusline == ''
  set statusline=[%n]\ %<%.99f\ %h%w%m%r%{XTry('CapsLockStatusline')}%y%{XTry('rails#statusline')}%{XTry('fugitive#statusline')}%#ErrorMsg#%{XTry('SyntasticStatuslineFlag')}%*%=%-14.(%l,%c%V%)\ %P
endif
set ttimeoutlen=50  " Make Esc work faster
if has('persistent_undo')
  set undofile
  set undodir^=~/.vim/tmp//,~/Library/Vim/undo
endif
set wildmenu

if $TERM == '^\%(screen\|xterm-color\)$' && t_Co == 8
  set t_Co=16
endif

let g:is_bash = 1 " Highlight all .sh files as if they were bash
let g:ruby_minlines = 500
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_rails = 1

let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDShutUp = 1
let g:netrw_list_hide = '^\.,^tags$'
let g:VCSCommandDisableMappings = 1

let g:surround_{char2nr('s')} = " \r"
let g:surround_{char2nr(':')} = ":\r"
let g:surround_indent = 1

runtime! plugin/matchit.vim
runtime! macros/matchit.vim

map Y       y$
nnoremap <silent> <Esc><Esc> :nohls<CR>
inoremap <C-C> <Esc>`^

cnoremap          <C-O> <Up>
inoremap              ø <C-O>o
inoremap          <M-o> <C-O>o
" Emacs style mappings
inoremap          <C-A> <C-O>^
inoremap     <C-X><C-@> <C-A>
cnoremap          <C-A> <Home>
cnoremap     <C-X><C-A> <C-A>
" If at end of a line of spaces, delete back to the previous line.
" Otherwise, <Left>
inoremap <silent> <C-B> <C-R>=getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"<CR>
cnoremap          <C-B> <Left>
" If at end of line, decrease indent, else <Del>
inoremap <silent> <C-D> <C-R>=col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"<CR>
" If at end of line, list matches, else <Del>
cnoremap   <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
" If at end of line, copy character below, else <End>
inoremap <silent> <C-E> <C-R>=col('.')>strlen(getline('.'))?"\<Lt>C-E>":"\<Lt>End>"<CR>
" If at end of line, fix indent, else <Right>
inoremap <silent> <C-F> <C-R>=col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"<CR>
" if at end of line, open command-line window, else <Right>
cnoremap   <expr> <C-F> getcmdpos()>strlen(getcmdline())?"\<Lt>C-F>":"\<Lt>Right>"

noremap           <F1>   <Esc>
noremap!          <F1>   <Esc>

" Enable TAB indent and SHIFT-TAB unindent
vnoremap <silent> <TAB> >gv
vnoremap <silent> <S-TAB> <gv

iabbrev bpry      require 'pry'; binding.pry

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/\\\@<!|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

if !exists('g:syntax_on')
  syntax on
endif
filetype plugin indent on

" Cursor shapes
if exists("g:use_cursor_shapes") && g:use_cursor_shapes
  if exists("$TMUX")
    let &t_SI = "\<Esc>[3 q"
    let &t_EI = "\<Esc>[0 q"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
endif

function! s:ExtractIntoRspecLet()
  let pos = getpos('.')
  if empty(matchstr(getline("."), " = ")) == 1
    echo "Can't find an assignment"
    return
  end
  normal 0
  normal! "tdd
  exec "?^\\s*\\<\\(describe\\|context\\)\\>"
  normal! $"tp
  exec 's/\v([a-z_][a-zA-Z0-9_]*) +\= +(.+)/let(:\1) { \2 }'
  normal V=
  let pos[1] = pos[1] + 1
  call setpos('.', pos)
  echo ''
endfunction

augroup organization
  autocmd!

  autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
        \ if isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif

  autocmd BufRead * if ! did_filetype() && getline(1)." ".getline(2).
        \ " ".getline(3) =~? '<\%(!DOCTYPE \)\=html\>' | setf html | endif

  autocmd FileType javascript,coffee      setlocal et sw=2 sts=2 isk+=$
  autocmd FileType html,xhtml,css,scss    setlocal et sw=2 sts=2
  autocmd FileType eruby,yaml,ruby        setlocal et sw=2 sts=2
  autocmd FileType cucumber               setlocal et sw=2 sts=2
  autocmd FileType gitcommit              setlocal spell
  autocmd FileType gitconfig              setlocal noet sw=8
  autocmd FileType ruby                   setlocal comments=:#\  tw=79
  autocmd FileType sh,csh,zsh             setlocal et sw=2 sts=2
  autocmd FileType vim                    setlocal et sw=2 sts=2 keywordprg=:help

  autocmd Syntax   css  syn sync minlines=50

  autocmd FileType ruby nmap <buffer> <leader>b <Plug>BlockToggle
  autocmd BufRead *_spec.rb nmap <buffer> <leader>l :<C-U>call <SID>ExtractIntoRspecLet()<CR>

  autocmd User Rails nnoremap <buffer> <D-r> :<C-U>Rake<CR>
  autocmd User Rails nnoremap <buffer> <D-R> :<C-U>.Rake<CR>
  autocmd User Fugitive command! -bang -bar -buffer -nargs=* Gpr :Git<bang> pull --rebase <args>
augroup END
