augroup color-scheme
  autocmd!
  autocmd ColorScheme peachpuff highlight Comment ctermfg=12 guifg=#5C80FF
  autocmd ColorScheme peachpuff highlight Pmenu ctermbg=3 ctermfg=0 guifg=#5C80FF
  autocmd ColorScheme peachpuff highlight PmenuSel ctermbg=0 ctermfg=2 guibg=black guifg=green cterm=BOLD gui=BOLD
augroup END
colorscheme peachpuff

set tabstop=4
set softtabstop=4
set shiftwidth=4

call plug#begin('~/.local/share/nvim/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'posva/vim-vue'
Plug 'digitaltoad/vim-pug'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'rhysd/wandbox-vim'
Plug 'rhysd/reply.vim'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'w0rp/ale'
Plug 'rking/ag.vim'
Plug 'hashivim/vim-terraform'
Plug 'lcolaholicl/vim-v'
Plug 'mattn/sonictemplate-vim'
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

augroup html-syntax
  autocmd!
  autocmd FileType html setlocal expandtab
  autocmd FileType html setlocal tabstop=2
  autocmd FileType html setlocal softtabstop=2
  autocmd FileType html setlocal shiftwidth=2
augroup END

augroup js-syntax
  autocmd!
  autocmd FileType javascript setlocal expandtab
  autocmd FileType javascript setlocal tabstop=2
  autocmd FileType javascript setlocal softtabstop=2
  autocmd FileType javascript setlocal shiftwidth=2
augroup END

augroup vue-syntax
  autocmd!
  autocmd FileType vue setlocal expandtab
  autocmd FileType vue setlocal tabstop=2
  autocmd FileType vue setlocal softtabstop=2
  autocmd FileType vue setlocal shiftwidth=2
augroup END

augroup sh-syntax
  autocmd!
  autocmd FileType sh setlocal expandtab
  autocmd FileType sh setlocal tabstop=2
  autocmd FileType sh setlocal softtabstop=2
  autocmd FileType sh setlocal shiftwidth=2
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
let g:ale_fixers['terraform'] = ['terraform']
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_linters = {}
let g:ale_linters['javascript'] = ['fecs', 'flow', 'flow-language-server', 'jscs', 'jshint', 'standard', 'tsserver', 'xo']
call ale#Set('python_flake8_executable', 'flake8')
call ale#Set('python_flake8_options', '--max-line-length=120')
call ale#Set('xml_xmllint_options', '--format')
" call ale#Set('go_golint_options', '-min_confidence=1.1')
call ale#Set('terraform_fmt_executable', '/usr/local/bin/terraform')
call ale#Set('javascript_prettier_options', '--print-width 120')

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
