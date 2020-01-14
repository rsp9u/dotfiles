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
Plug 'cespare/vim-toml'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
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

augroup fn-abbrevitions
  autocmd!
  autocmd Filetype python iabbrev <buffer> fn def
  autocmd Filetype go iabbrev <buffer> fn func
  autocmd Filetype javascript iabbrev <buffer> fn function
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
let g:ale_linters = {}
let g:ale_linters['python'] = ['flake8', 'pylint']
let g:ale_fixers = {}
let g:ale_fixers['sql'] = ['sqlfmt']
let g:ale_fixers['xml'] = ['xmllint']
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fix_on_save = 1
call ale#Set('python_flake8_executable', 'flake8')
call ale#Set('python_flake8_options', '--max-line-length=120')
call ale#Set('python_pylint_executable', 'pylint')
call ale#Set('python_pylint_options', '--disable=all --enable=no-member,no-name-in-module')
call ale#Set('sql_sqlfmt_options', '-u')

function! FixGoFmtOnDocker(buffer, lines) abort
  return {'command': '/usr/local/bin/gofmt -e %t'}
endfunction
call ale#fix#registry#Add('fix_gofmt', 'FixGoFmtOnDocker', ['go'], 'Go format')
let g:ale_fixers['go'] = ['fix_gofmt']

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

augroup side-filtype
  autocmd!
  autocmd BufRead,BufNewFile *.side set filetype=side
  autocmd BufRead,BufNewFile *.side set syntax=yaml
augroup END

function! FixSideOrder(buffer, lines) abort
  return {'command': '/usr/local/bin/fix_side_order.py --clear-targets --stdout %t'}
endfunction
call ale#fix#registry#Add('fix_side_order', 'FixSideOrder', ['side'], 'Reorder SIDE file')
"let g:ale_fixers['side'] = ['fix_side_order']
let g:ale_fixers['side'] = []
