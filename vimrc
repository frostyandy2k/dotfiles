" Can not use the next setting with tmux
set t_Co=256 

colorscheme koehler

" Do not set ts=4, if does, can't really tell the difference between
" tab/space. It will be easy to tell someone mess up the coding style.
set ai sts=4 et
set sw=4
set tw=0

" Showing space-indentation, evolved from the following links
" http://www.vim.org/scripts/script.php?script_id=1800
" http://viming.blogspot.com/2007/02/indent-level-highlighting.html
imap <F8><F10> <ESC>:call Ctab()<CR><INSERT><RIGHT>
nmap <F8><F10> <ESC>:call Ctab()<CR>
let CtabOn=0
function! Ctab()
  if g:CtabOn == 0
    for i in range(1, 7)
      if i == 1
        syn match cTab1 /^ \{2}/
      else
        let pat='/\(^ \{'.(i-1)*2.'}\)\@<=  /'
        exec 'syn match cTab'.i pat
      endif

      if i % 2 == 0
        exec 'hi def cTab' . i . ' term=NONE cterm=NONE ctermbg=' . (i/2+235)
      else
        exec 'hi def cTab' . i . ' term=NONE cterm=NONE ctermbg=NONE'
      endif
    endfor
    let g:CtabOn = 1
  else
    for i in range(1, 7)
      exec 'syntax clear cTab' . i
      exec 'highlight clear cTab' . i
    endfor
    let g:CtabOn = 0
  endif
endfunction

" Showing red border at column 77 and 78
hi ColorColumn ctermbg=124
imap <F8><F8> <ESC>:call SetCC()<CR><INSERT><RIGHT>
nmap <F8><F8> <ESC>:call SetCC()<CR>
function! SetCC()
    let _cc = getwinvar(0, '&cc')
    if _cc == 0
        call setwinvar(0, '&cc', '77,78')
    else
        call setwinvar(0, '&cc', '')
    endif
endfunction

" Showing cross cursor
hi CursorColumn term=NONE cterm=NONE ctermbg=240
hi CursorLine term=NONE cterm=NONE ctermbg=240
imap <F8><F9> <ESC>:set cuc! cul!<CR><INSERT><RIGHT>
nmap <F8><F9> <ESC>:set cuc! cul!<CR>

" Showing tab and tailing space
set lcs=tab:»⋅,trail:◊ "&raquo; and U+22C5, U+9674=&loz;
hi SpecialKey ctermfg=239
"hi NonText ctermfg=234
imap <F8><F7> <ESC>:set list!<CR><INSERT><RIGHT>
nmap <F8><F7> <ESC>:set list!<CR>

set mouse=a
set ttymouse=xterm2
set sessionoptions=blank,buffers,curdir,folds,help,resize,tabpages,winsize
" http://www.linux.com/archive/articles/54936
imap <F6> <ESC>:set ttym=xterm2<CR>
nmap <F6> <ESC>:set ttym=xterm2<CR>
imap <F6><F6> <ESC>:set ttym=<CR>
nmap <F6><F6> <ESC>:set ttym=<CR>

imap <C-X><C-X> <ESC>:tabnew<CR>
nmap <C-X><C-X> :tabnew<CR>
imap <C-X><Left> <ESC>:tabp<CR>
nmap <C-X><Left> :tabp<CR>
imap <C-X><Right> <ESC>:tabn<CR>
nmap <C-X><Right> :tabn<CR>
" no highlight
imap <C-X>8 <ESC>:nohl<CR><Insert><Right>
nmap <C-X>8 :nohl<CR>
 
imap <F4> <C-R>=strftime("%FT%TZ", localtime()-8*3600)<CR>
nmap <F4> "=strftime("%FT%TZ", localtime()-8*3600)<CR>p

" Fix key control codes
map [31~ <S-F7>

" Spell check
map <F7> <ESC>:setlocal spell! spelllang=en_us<CR>

set pastetoggle=<F12>
set modeline

" " For i18n
" vmap <F2> "xd"="__("<CR>P"xp"=")"<CR>p
" vmap <F2><F2> "xd"="_e("<CR>P"xp"=")"<CR>p
" "nmap <F3> :.s/_[_e](\(['"]\).\{-}\1)/<?php &; ?>/g<CR> :nohlsearch<CR>
" vmap <F3> "xd"="<?php _e('"<CR>P"xp"="'); ?>"<CR>p
" 
" fu! LoadPHPDebugger()
"     so $HOME/.vim/plugin/debugger
"     echo "PHP Debugger loaded."
" endf

set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words

" For Python source
" autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
autocmd BufRead *.py set tabstop=2
autocmd BufRead *.py set shiftwidth=2
autocmd BufRead *.py set smarttab
autocmd BufRead *.py set expandtab
autocmd BufRead *.py set softtabstop=2
autocmd BufRead *.py set autoindent
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

fu! CheckGoogleGadgets()
	let gg=0
	silent! exec 'g/<Content type="html">/let gg=1'
	if gg==1
		runtime! syntax/GoogleGadgets.vim
		echo "Google Gadgets syntax loaded."
	endif
endf

autocmd BufRead *.xml call CheckGoogleGadgets()

" http://blog.sontek.net/2008/05/11/python-with-a-modular-ide-vim/
" Freely jump between your code and python class libraries
python << EOF
import os
import sys
import vim
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF

set tags+=$HOME/.vim/tags/python.ctags

" Code Completion
autocmd FileType python set omnifunc=pythoncomplete#Complete

" Syntax Checking
" http://vim.wikia.com/wiki/Python_-_check_syntax_and_run_script
autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
autocmd BufRead *.py nmap <F5> :!python %<CR>

python << EOL
import vim
def EvaluateCurrentRange():
	eval(compile('\n'.join(vim.current.range),'','exec'),globals())
EOL
map <C-h> :py EvaluateCurrentRange()<CR>

" Set shell title
" http://vim.wikia.com/wiki/Automatically_set_screen_title
let &titlestring = "vim:" . expand("%:t")
if &term == "screen"
  " ^[ is by pressing Ctrl+V ESC
  set t_ts=k
  set t_fs=\
endif
if &term == "screen" || &term == "xterm" || &term == "urxvt"
  set title
endif

" Append modeline after last line in buffer.
" Use substitute() (not printf()) to handle '%%s' modeline in LaTeX files.
" http://vim.wikia.com/wiki/Modeline_magic
function! AppendModeline()
  let save_cursor = getpos('.')
  let append = ' vim: set ts='.&tabstop.' sw='.&shiftwidth.' tw='.&textwidth.': '
  $put =substitute(&commentstring, '%s', append, '')
  call setpos('.', save_cursor)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>


" Markdown syntax
" http://plasticboy.com/markdown-vim-mode/
augroup mkd

  autocmd BufRead *.mkd set tabstop=2
  autocmd BufRead *.mkd set shiftwidth=2
  autocmd BufRead *.mkd set smarttab
  autocmd BufRead *.mkd set expandtab
  autocmd BufRead *.mkd set softtabstop=2

  autocmd BufRead *.mkd set ai formatoptions=tcroqn2 comments=n:&gt;

  autocmd BufRead *.mkd map <F5> <ESC>:w<CR>:!gen-blog-markdown.sh "%"<CR>
  autocmd BufRead *.mkd imap <F5> <ESC>:w<CR>:!gen-blog-markdown.sh "%"<CR>

augroup END

" For Chrome Extension manifest.json
augroup json

  autocmd BufRead *.json set tabstop=2
  autocmd BufRead *.json set shiftwidth=2
  autocmd BufRead *.json set smarttab
  autocmd BufRead *.json set expandtab
  autocmd BufRead *.json set softtabstop=2
  autocmd BufRead *.json set ai
  autocmd BufRead *.json set syntax=javascript
  
augroup END

" https://github.com/xolox/vim-notes
let g:notes_directory = '~/Documents/VimNotes'
let g:notes_tagsindex = '~/Documents/VimNotes/tags.txt'

" vim: set sw=2 et: