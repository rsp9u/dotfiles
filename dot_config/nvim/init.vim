""""""""""""""""""""""""""""""""
" Base settings
""""""""""""""""""""""""""""""""
" color
syntax enable
augroup color-scheme
  autocmd!
  autocmd ColorScheme peachpuff highlight String ctermfg=9 guifg=#FF0000
  autocmd ColorScheme peachpuff highlight Comment ctermfg=12 guifg=#5C80FF
  autocmd ColorScheme peachpuff highlight Pmenu ctermbg=3 ctermfg=0 guifg=#5C80FF
  autocmd ColorScheme peachpuff highlight PmenuSel ctermbg=0 ctermfg=2 guibg=black guifg=green cterm=BOLD gui=BOLD
augroup END
colorscheme peachpuff

" default
set hlsearch
set tabpagemax=100
augroup tab-default
  autocmd!
  autocmd BufRead,BufNew * setlocal autoindent
  autocmd BufRead,BufNew * setlocal expandtab
  autocmd BufRead,BufNew * setlocal tabstop=4
  autocmd BufRead,BufNew * setlocal softtabstop=4
  autocmd BufRead,BufNew * setlocal shiftwidth=4
augroup END

" Plug
call plug#begin('~/.local/share/nvim/plugged')
" preference loader
Plug 'editorconfig/editorconfig-vim'
" syntax support
Plug 'neoclide/jsonc.vim'
Plug 'cespare/vim-toml'
Plug 'posva/vim-vue'
Plug 'digitaltoad/vim-pug'
Plug 'mxw/vim-jsx'
Plug 'JuliaEditorSupport/julia-vim'
" editor assistant
Plug 'tpope/vim-surround'
Plug 'bkad/CamelCaseMotion'
" code static analysis
Plug 'w0rp/ale'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
" command line tool
Plug 'rking/ag.vim'
Plug 'rhysd/reply.vim'
" additional feature
Plug 'mattn/sonictemplate-vim'
Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

" settings per filetype
augroup vim-syntax
  autocmd!
  autocmd Filetype vim setlocal tabstop=2
  autocmd Filetype vim setlocal softtabstop=2
  autocmd Filetype vim setlocal shiftwidth=2
augroup END

augroup go-syntax
  autocmd!
  autocmd FileType go setlocal noexpandtab
augroup END

augroup yaml-syntax
  autocmd!
  autocmd FileType yaml setlocal tabstop=2
  autocmd FileType yaml setlocal softtabstop=2
  autocmd FileType yaml setlocal shiftwidth=2
augroup END

augroup html-syntax
  autocmd!
  autocmd FileType html setlocal tabstop=2
  autocmd FileType html setlocal softtabstop=2
  autocmd FileType html setlocal shiftwidth=2
augroup END

augroup web-syntax
  autocmd!
  autocmd FileType javascript setlocal tabstop=2
  autocmd FileType javascript setlocal softtabstop=2
  autocmd FileType javascript setlocal shiftwidth=2
  autocmd FileType typescript setlocal tabstop=2
  autocmd FileType typescript setlocal softtabstop=2
  autocmd FileType typescript setlocal shiftwidth=2
  autocmd FileType javascript.jsx setlocal tabstop=2
  autocmd FileType javascript.jsx setlocal softtabstop=2
  autocmd FileType javascript.jsx setlocal shiftwidth=2
  autocmd FileType vue setlocal tabstop=2
  autocmd FileType vue setlocal softtabstop=2
  autocmd FileType vue setlocal shiftwidth=2
augroup END

augroup sh-syntax
  autocmd!
  autocmd FileType sh setlocal tabstop=2
  autocmd FileType sh setlocal softtabstop=2
  autocmd FileType sh setlocal shiftwidth=2
augroup END

augroup k8s-gitsync
  autocmd!
  autocmd BufRead,BufNewFile *.helm setfiletype yaml
augroup END

" misc settings
augroup quick-fix-window
  autocmd!
  " set 6 lines for quick-fix window height
  autocmd FileType qf 6wincmd_
augroup END

augroup external-command
  autocmd!
  " the silver searcher command
  autocmd BufRead,BufNew * nnoremap + :execute "Ag " . expand("<cword>")<CR>
  autocmd BufRead,BufNew * vnoremap + y:Ag <C-R>"<CR>
  " execute system command and paste to under the cursor
  autocmd BufRead,BufNew * nnoremap Q :execute "norm i" . trim(system(""))<Left><Left><Left>
augroup END
echo

""""""""""""""""""""""""""""""""
" Plugin settings
""""""""""""""""""""""""""""""""

" jsonc.vim
augroup jsonc-ftdetect
  autocmd!
  autocmd BufNewFile,BufRead tsconfig.json setlocal filetype=jsonc
augroup END

" vim-lsp
let g:lsp_log_verbose = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_signs_enabled = 1
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1
nnoremap gd :LspDefinition<CR>

" ale
let g:ale_fix_on_save = 1
let g:ale_fixers = {}
let g:ale_fixers['go'] = ['gofmt']
let g:ale_fixers['xml'] = ['xmllint']
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_linters = {}
let g:ale_linters['javascript'] = ['fecs', 'flow', 'flow-language-server', 'jscs', 'jshint', 'standard', 'tsserver', 'xo']
call ale#Set('python_flake8_executable', 'flake8')
call ale#Set('python_flake8_options', '--max-line-length=180')
call ale#Set('xml_xmllint_options', '--format')
call ale#Set('terraform_fmt_executable', '/usr/local/bin/terraform')
call ale#Set('javascript_prettier_options', '--print-width 120')

" CamelCaseMotion
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
map <silent> ge <Plug>CamelCaseMotion_ge
sunmap w
sunmap b
sunmap e
sunmap ge
omap <silent> iw <Plug>CamelCaseMotion_iw
xmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
xmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
xmap <silent> ie <Plug>CamelCaseMotion_ie

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = 'node_modules\|\.git'
let g:ctrlp_prompt_mappings = { 'AcceptSelection("e")': [], 'AcceptSelection("t")': ['<cr>', '<c-t>'] }
