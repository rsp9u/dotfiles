syntax on
colorscheme desert
set expandtab
set autoindent
set hlsearch
set ts=4
set sts=4
set sw=4
set tabpagemax=100

call plug#begin('~/.local/share/nvim/plugged')
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'w0rp/ale'
Plug 'rhysd/reply.vim'
Plug 'rhysd/wandbox-vim'
Plug 'leafgarland/typescript-vim'
Plug 'rking/ag.vim'
call plug#end()

filetype plugin indent on
syntax enable

augroup vim-syntax
  autocmd!
  autocmd Filetype vim setlocal tabstop=2
  autocmd Filetype vim setlocal softtabstop=2
  autocmd Filetype vim setlocal shiftwidth=2
augroup END

augroup go-syntax
  autocmd!
  autocmd FileType go setlocal noexpandtab
  autocmd FileType go setlocal tabstop=4
  autocmd FileType go setlocal shiftwidth=4
augroup END

augroup yaml-syntax
  autocmd!
  autocmd FileType yaml setlocal tabstop=2
  autocmd FileType yaml setlocal softtabstop=2
  autocmd FileType yaml setlocal shiftwidth=2
augroup END

augroup js-syntax
  autocmd!
  autocmd FileType javascript setlocal tabstop=2
  autocmd FileType javascript setlocal softtabstop=2
  autocmd FileType javascript setlocal shiftwidth=2
augroup END

augroup reply-vim-settings
  autocmd!
  autocmd BufNewFile * noremap <C-i> :ReplAuto<CR>
augroup END

nnoremap + :execute "Ag " . expand("<cword>")<CR>
vnoremap + y:Ag <C-R>"<CR>

augroup quick-fix-window
  autocmd!
  autocmd FileType qf 6wincmd_
augroup END

" execute system command and paste to under the cursor
nnoremap Q :execute "norm i" . trim(system(""))<Left><Left><Left>
