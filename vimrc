call pathogen#infect()
filetype off
call pathogen#incubate()
call pathogen#helptags()
filetype on

" Keep cursor vertically centered
set so=999

" Auto change the directory
autocmd BufEnter * silent! lcd %:p:h

" Hack to disable auto dir change after loading vim (required when you have autochdir set)
autocmd VimEnter * "set noautochdir"

" C++ Configuration - http://vim.wikia.com/wiki/VimTip1608
" configure tags - add additional tags here or comment out not-used ones
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/gl
set tags+=~/.vim/tags/linux
set tags+=~/.vim/tags/qt5.2.0
" build tags of your own project with Ctrl-F12
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview


"   Set to 1 to get paths with metachars replaced by . as path hashes
"   Default is 0, md5sum hash is used
let g:autotags_pathhash_humanreadable = 1
let g:autotags_ctags_exe = "ctags"
let g:autotags_ctags_opts = "-R"

"   see `man ctags` "--languages" options
let g:autotags_ctags_languages = "all"

let g:autotags_no_global = 1 " disable tagging global directories
" let g:autotags_ctags_global_include = "/usr/include/*" " this can be useful
" for 3rd party libraries such as Qt, Boost where all includes files are
" separately located

" ==== For NERDTree Plugin
" let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeWinSize = 45
" let g:nerdtree_tabs_open_on_console_startup = 1
let NERDTreeShowBookmarks=1

"
" General vim settings common to both CLI and GUI versions
" 
set autochdir " required if you want NERDTree to switch to the editor buffer path, see above: after entering we disable this feature
set path=.,/Volumes/www,/home/purinda/
" Highlight current line 
highlight CursorLine guibg=grey20
set cursorline
set cindent
set smartindent
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set cinkeys=0{,0},:,0#,!^F
set showcmd
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smarttab

"
" Color schemes and theme settings
"
set background=dark
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif

colorscheme molokai
set showmatch
" set nohlsearch
set nowrap
set whichwrap=b,s,<,>,[,],~
set hlsearch
set incsearch
set shortmess=I
set laststatus=2
set foldmethod=marker
set number
set nocompatible
set wildmode=longest:full
set wildmenu
set formatprg=par-format\ -w80
" use 'gqip' to format.
set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set showtabline=2
"set hidden
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set backspace=indent,eol,start
set whichwrap+=<,>,[,]
" No backup files
set noswapfile
set nobk
" Set a custom backup directory so no annyoing temp files in project directories
set backupdir=~/.vim/tmp,.
set directory=~/.vim/tmp,.

highlight ColorColumn ctermbg=darkgrey
highlight StatusLine cterm=none ctermfg=black
highlight LineNr ctermfg=darkgrey
highlight CursorLine ctermbg=darkgrey
highlight CursorColumn ctermbg=darkgrey ctermfg=darkgrey
highlight Vertsplit ctermbg=darkgrey ctermfg=darkgrey
highlight Visual ctermbg=52
" Highlight whitespace.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" save a hostname variable.
" let hostname = substitute(system('hostname'), '\n', '', '')

filetype plugin on
syntax on

setlocal spelllang=en_au

" Uncomment the following to have Vim jump to the last position when
" reopening a file
" if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

augroup chmodandshebang
    autocmd!
    autocmd BufWritePost *.sh,*.pl,*.rb,*.py :exe "silent !chmod 700 <afile>" | silent :w!
    autocmd BufEnter *.sh if getline(1) == "" | :call setline(1, "#!/bin/bash") | endif
    autocmd BufEnter *.pl if getline(1) == "" | :call setline(1, "#!/usr/bin/env perl") | endif
    autocmd BufEnter *.pb if getline(1) == "" | :call setline(1, "#!/usr/bin/env ruby") | endif
    autocmd BufEnter *.py if getline(1) == "" | :call setline(1, "#!/usr/bin/env python") | endif
augroup END

" Turn on spell checking when writting a GIT commit.
autocmd FileType gitcommit set spell

" Common Indentation.
if has("autocmd")
  " Enable file type detection
  filetype on

  autocmd FileType yaml          setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType html          setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType css           setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript    setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType python        setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType ruby          setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType bash          setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType cpp           setlocal ts=4 sts=4 sw=4 expandtab

  " TagList and NERDTree for script files
  autocmd BufNewFile,BufRead *.php,*.gpx,*.c,*.cpp,*.h,*.hpp,*.java,*.js,*.sh,*.php,*.inc,*.pl execute ":TagbarOpen"
  " autocmd BufNewFile,BufRead *.php,*.gpx,*.c,*.cpp,*.h,*.hpp,*.java,*.js,*.sh,*.php,*.inc,*.pl execute ":NERDTreeTabsOpen"

endif

" Work
if hostname() == 'purinda-pc1' || hostname() == 'purinda-pc1.syd.gptech.local'
    " handle gpx files as php.
    au BufRead,BufNewFile *.gpx let is_php=1|setfiletype php
    au BufRead,BufNewFile *.gpx setlocal ts=4 sts=4 sw=4 expandtab
    au BufRead,BufNewFile *.inc let is_php=1|setfiletype php
    au BufRead,BufNewFile *.inc setlocal ts=4 sts=4 sw=4 expandtab
    au BufRead,BufNewFile *.tpl let is_smarty=1|setfiletype smarty
    au BufRead,BufNewFile *.tpl setlocal ts=2 sts=2 sw=2 expandtab

    autocmd BufNewFile */tpl/*.tpl 0r $HOME/.gptech-templates/gptech.tpl
    autocmd BufNewFile */www/*.gpx 0r $HOME/.gptech-templates/gptech.gpx
    autocmd BufNewFile */inc/*.php 0r $HOME/.gptech-templates/gptech.php
endif

" nnoremap <up> <nop>
" nnoremap <down> <nop>
" nnoremap <left> <nop>
" nnoremap <right> <nop>
nnoremap <silent> <leader>k :wincmd k<CR>
nnoremap <silent> <leader>j :wincmd j<CR>
nnoremap <silent> <leader>h :wincmd h<CR>
nnoremap <silent> <leader>l :wincmd l<CR>
nnoremap <silent> <leader>[ :wincmd h<CR>
nnoremap <silent> <leader>] :wincmd l<CR>
nnoremap <silent> <leader>o :only<CR>
" nnoremap <silent> <leader>- :vsplit <cr>:exec("tag ".expand("<cword>"))<cr>
nnoremap <silent> <leader>bl :buffers<CR>
nnoremap <silent> <leader>ls :!ls -l<CR>
nnoremap <silent> <leader>tr :!tree<CR>
nnoremap <silent> <leader>svns :!svn status<CR>
nnoremap <leader>p :set paste!<CR>
nnoremap <leader>n :set number!<CR>
nnoremap <leader>s :set spell!<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>ob :TagbarToggle<CR>
inoremap jk <esc>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap ;; :w<cr>
nnoremap <silent> <leader>; :BufExplorer<cr>
nnoremap <leader>- :tabprevious<cr>
nnoremap <leader>= :tabnext<cr>
nnoremap <leader>m :set mouse=a<cr>
nnoremap <leader>mm :set mouse=<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

" Toggle between .gpx and there corresponding .tpl files
function! ToggleGpxTpl ()
    let l:ext = expand('%:e')
    let l:filepath = substitute(expand('%:p'), '\/usr\/sentral\/www', '', '')
    echo filepath
    if l:ext == 'gpx'
        let l:filepath = substitute(expand(l:filepath), 'www', 'tpl', '')
        let l:filepath = substitute(expand(l:filepath), '.gpx', '.tpl', '')
    else
        let l:filepath = substitute(expand(l:filepath), 'tpl', 'www', '')
        let l:filepath = substitute(expand(l:filepath), '.tpl', '.gpx', '')
    endif
    execute ":edit /usr/sentral/www" . l:filepath
endfunction
nnoremap <silent> <leader>' :call ToggleGpxTpl()<CR>

" autocmd BufWinLeave * call clearmatches()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PHP Stuff.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

:autocmd Filetype php call Filetype_Php()

function! Filetype_Php()

    " PHP parser check (CTRL-L)
    nmap <Leader>pl :!/usr/bin/php -l %<CR>

    set keywordprg=pman

    "If you like SQL syntax hightlighting inside Strings: >
    let php_sql_query = 1

    ""Enable HTML syntax highlighting inside strings: >
    let php_htmlInStrings = 1

    "For highlighting parent error ] or ): >
    let php_parent_error_close = 1

    setlocal ts=4 sts=4 sw=4 expandtab

endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"end PHP Stuff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Strip trailing white space.
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
" call the above function automatically when saving files of certain type.
autocmd BufWritePre *.py,*.js,*.php,*.gpx,*.rb :call <SID>StripTrailingWhitespaces()

" php code sniffer via :Rhpcs
function! RunPhpcs()
    let l:filename=@%
    let l:phpcs_output=system('phpcs --report=csv --standard=Zend '.l:filename)
    let l:phpcs_list=split(l:phpcs_output, "\n")
    unlet l:phpcs_list[0]
    cexpr l:phpcs_list
    cwindow
endfunction
set errorformat+=\"%f\"\\,%l\\,%c\\,%t%*[a-zA-Z]\\,\"%m\"
command! Rhpcs execute RunPhpcs()

" Use <Leader>ee to execute a command under the cursor within a file.
function! EC()
    let l:Command = getline(".")
    execute "!" . l:Command
endfunction
command! Ec execute EC()
nmap <Leader>x :Ec<CR>

function! BufSel(pattern)
  let bufcount = bufnr("$")
  let currbufnr = 1
  let nummatches = 0
  let firstmatchingbufnr = 0
  while currbufnr <= bufcount
    if(bufexists(currbufnr))
      let currbufname = bufname(currbufnr)
      if(match(currbufname, a:pattern) > -1)
        echo currbufnr . ": ". bufname(currbufnr)
        let nummatches += 1
        let firstmatchingbufnr = currbufnr
      endif
    endif
    let currbufnr = currbufnr + 1
  endwhile
  if(nummatches == 1)
    execute ":buffer ". firstmatchingbufnr
  elseif(nummatches > 1)
    let desiredbufnr = input("Enter buffer number: ")
    if(strlen(desiredbufnr) != 0)
      execute ":buffer ". desiredbufnr
    endif
  else
    echo "No matching buffers"
  endif
endfunction
"Bind the BufSel() function to a user-command
command! -nargs=1 Bs :call BufSel("<args>")


