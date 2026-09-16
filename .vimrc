set number

set autoindent
set tabstop=4
set expandtab
set softtabstop=4
syntax on
highlight Visual ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black

" These is for extensions
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'

call plug#end()
