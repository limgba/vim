if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
  autocmd!
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add $PWD/cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

set number
syntax off
set tags=tags;
set autochdir
set ic

if has("cscope")
	set csprg=/usr/bin/cscope
	set csto=0
	set cst
	set nocsverb
	if filereadable("cscope.out")
		cs add cscope.out
	else
		let cscope_file=findfile("cscope.out",",;")
		let cscope_pre=matchstr(cscope_file,".*/")
		if !empty(cscope_file)&&filereadable(cscope_file)
			exe "cs add" cscope_file cscope_pre
		endif
	endif
endif

nmap <C-[>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-[>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-[>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-[>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-[>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-[>f :cs find i <C-R>=expand("<cword>")<CR><CR>
nmap <C-[>i :cs find i <C-R>=expand("<cword>")<CR><CR>
nmap <C-[>d :cs find d <C-R>=expand("<cword>")<CR><CR>

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"
