colorscheme desert
set hlsearch
set tabpagemax=100

augroup basic-settings
  autocmd!
  autocmd BufRead,BufNew * setlocal autoindent
  autocmd BufRead,BufNew * setlocal expandtab
  autocmd BufRead,BufNew * setlocal tabstop=4
  autocmd BufRead,BufNew * setlocal softtabstop=4
  autocmd BufRead,BufNew * setlocal shiftwidth=4
augroup END

call plug#begin('~/.local/share/nvim/plugged')
Plug 'w0rp/ale'
Plug 'rhysd/reply.vim'
Plug 'rhysd/wandbox-vim'
Plug 'leafgarland/typescript-vim'
Plug 'rking/ag.vim'
Plug 'prabirshrestha/async.vim'
call plug#end()

filetype plugin indent on
syntax enable

augroup basic-map
  autocmd!
  " exit from insert mode
  autocmd BufRead,BufNew * inoremap jj <Esc>
  autocmd BufRead,BufNew * inoremap jk <Esc>
  " the silver searcher command
  autocmd BufRead,BufNew * nnoremap + :execute "Ag " . expand("<cword>")<CR>
  autocmd BufRead,BufNew * vnoremap + y:Ag <C-R>"<CR>
  " execute system command and paste to under the cursor
  autocmd BufRead,BufNew * nnoremap Q :execute "norm i" . trim(system(""))<Left><Left><Left>
augroup END

augroup python-abbreviations
  autocmd!
  autocmd Filetype python iabbrev <buffer> lam lambda
  autocmd Filetype python iabbrev <buffer> isins isinstance
  autocmd Filetype python iabbrev <buffer> enum enumerate
  autocmd Filetype python iabbrev <buffer> fr from import<Left><Left><Left><Left><Left><Left><Left>
  autocmd Filetype python iabbrev <buffer> ifmain if __name__ == '__main__':
augroup END

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

augroup quick-fix-window
  autocmd!
  autocmd FileType qf 6wincmd_
augroup END

" ale
let g:ale_linters = { 'python': ['flake8'] }
call ale#Set('python_flake8_executable', 'flake8')
call ale#Set('python_flake8_options', '--max-line-length=120')

" editor for SIDE file
function! RegenUuidJson() abort
  for n in range(a:firstline, a:lastline)
    let line = getline(n)
    if line =~ '"id":'
      let olduuid = substitute(line, '\(^.*"id": "\)\([A-Za-z0-9-]*\)\(".*$\)', '\2', '')
      let newuuid = trim(system('uuidgen'))
      silent execute '%s/'.olduuid.'/'.newuuid.'/g'
    endif
  endfor
endfunction

command! -nargs=0 -range=% RegenUuidJson :<line1>,<line2>call RegenUuidJson()
