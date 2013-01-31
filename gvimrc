set go-=T
set bg=light
if &background == "dark"
    hi normal guibg=black
endif

colorscheme lucius
LuciusDark

" Set font
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 9
  elseif has("gui_win32")
    set guifont=Consolas:h9:cANSI
  endif
endif

" Start maximized
if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window.
  set lines=999 columns=999
endif
