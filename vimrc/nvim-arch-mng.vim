augroup color-scheme
  autocmd!
  autocmd ColorScheme peachpuff highlight Comment ctermfg=12 guifg=#5C80FF
augroup END
colorscheme peachpuff

set tabstop=4
set softtabstop=4
set shiftwidth=4

call plug#begin('~/.local/share/nvim/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'posva/vim-vue'
Plug 'digitaltoad/vim-pug'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'rhysd/wandbox-vim'
Plug 'rhysd/reply.vim'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'w0rp/ale'
Plug 'rking/ag.vim'
call plug#end()

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

let g:lsp_log_verbose = 1
"let g:lsp_log_file = expand('~/vim-lsp.log')
let g:lsp_diagnostics_enabled = 1
let g:lsp_signs_enabled = 1

"let g:asyncomplete_log_file = expand('~/asyncomplete.log')
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1

nnoremap gd :LspDefinition<CR>

augroup wandbox-settings
  autocmd!
  autocmd FileType c noremap <buffer><Leader>ww :Wandbox --compiler=gcc-head<CR>
augroup END

nnoremap + :execute "Ag " . expand("<cword>")<CR>
vnoremap + y:Ag <C-R>"<CR>

augroup quick-fix-window
  autocmd!
  autocmd FileType qf 6wincmd_
augroup END

" execute system command and paste to under the cursor
nnoremap Q :execute "norm i" . trim(system(""))<Left><Left><Left>

" ale
let g:ale_fix_on_save = 1
let g:ale_fixers = {}
let g:ale_fixers['go'] = ['gofmt']
let g:ale_fixers['xml'] = ['xmllint']
call ale#Set('python_flake8_executable', 'flake8')
call ale#Set('python_flake8_options', '--max-line-length=120')
call ale#Set('xml_xmllint_options', '--format')
" call ale#Set('go_golint_options', '-min_confidence=1.1')

" side editor
function! RegenUuidJson() abort
  for n in range(a:firstline, a:lastline)
    let line = getline(n)
    if line =~ '"id":'
      let olduuid = substitute(line, '\(^.*"id": "\)\([A-Za-z0-9-]*\)\(".*$\)', '\2', '')
      let newuuid = trim(system('uuidgen'))
	  call setline(n, substitute(line, olduuid, newuuid, ''))
    endif
  endfor
endfunction

function! RegenUuidYaml() abort
  for n in range(a:firstline, a:lastline)
    let line = getline(n)
    if line =~ 'id: '
      let olduuid = substitute(line, '\(^.*id: [''"]\?\)\([A-Za-z0-9-]*\)\([''"]\?.*$\)', '\2', '')
      let newuuid = trim(system('uuidgen'))
	  silent execute '%s/'.olduuid.'/'.newuuid.'/g'
    endif
  endfor
endfunction

command! -nargs=0 -range=% RegenUuidJson :<line1>,<line2>call RegenUuidJson()
command! -nargs=0 -range=% RegenUuidYaml :<line1>,<line2>call RegenUuidYaml()
