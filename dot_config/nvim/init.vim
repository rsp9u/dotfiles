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
set autoindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

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
Plug 'pangloss/vim-javascript'
Plug 'evanleck/vim-svelte', {'branch': 'main'}
Plug 'ziglang/zig.vim'
" editor assistant
Plug 'tpope/vim-surround'
" code static analysis
"Plug 'w0rp/ale'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'
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
  autocmd FileType go setlocal tabstop=4
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

" activate left tab after tab close
let s:after_tab_leave = v:false
augroup activate-left-tab
  autocmd!
  autocmd TabEnter * let s:after_tab_leave = v:false
  autocmd TabLeave * let s:after_tab_leave = v:true
  autocmd TabClosed * call s:activate_left(expand('<afile>'))
augroup END
function! s:activate_left(tab_number) abort
  let current = tabpagenr()
  if s:after_tab_leave && current != 1 && current == a:tab_number
    tabprevious
  endif
endfunction

" make directory for current file automatically
" from: https://stackoverflow.com/questions/4292733/vim-creating-parent-directories-on-save
function s:MakeDirIfNotExists(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction
augroup write-create-directory
  autocmd!
  autocmd BufWritePre * :call s:MakeDirIfNotExists(expand('<afile>'), +expand('<abuf>'))
augroup END

""""""""""""""""""""""""""""""""
" Plugin settings
""""""""""""""""""""""""""""""""

" vim-svelte
let g:svelte_indent_script = 0
let g:svelte_indent_style = 0

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


" Enable flake8
let g:lsp_settings = {
\  'pylsp-all': {
\    'workspace_config': {
\      'pylsp': {
\        'configurationSources': ['flake8'],
\        'plugins': {
\          'flake8': {'enabled': 1},
\          'mccabe': {'enabled': 0},
\          'pycodestyle': {'enabled': 0},
\          'pyflakes': {'enabled': 0},
\        }
\      }
\    }
\  }
\}

" " ale
" let g:ale_fix_on_save = 1
" let g:ale_fixers = {}
" let g:ale_fixers['go'] = ['gofmt']
" let g:ale_fixers['xml'] = ['xmllint']
" let g:ale_linters = {}
" let g:ale_linters['javascript'] = ['fecs', 'flow', 'flow-language-server', 'jscs', 'jshint', 'standard', 'tsserver', 'xo']
" call ale#Set('python_flake8_executable', 'flake8')
" call ale#Set('python_flake8_options', '--max-line-length=180')
" call ale#Set('xml_xmllint_options', '--format')
" call ale#Set('terraform_fmt_executable', '/usr/local/bin/terraform')

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = 'node_modules\|\.git'
let g:ctrlp_prompt_mappings = { 'AcceptSelection("e")': [], 'AcceptSelection("t")': ['<cr>', '<c-t>'] }
