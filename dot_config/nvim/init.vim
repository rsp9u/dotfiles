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

augroup keymap-change
  autocmd!
  " omni completion
  autocmd BufRead,BufNew * inoremap <C-O> <C-X><C-O>
augroup END

augroup external-command
  autocmd!
  " the silver searcher command
  autocmd BufRead,BufNew * nnoremap + :execute "Ag " . expand("<cword>")<CR>
  autocmd BufRead,BufNew * vnoremap + y:Ag <C-R>"<CR>
  " execute system command and paste to under the cursor
  autocmd BufRead,BufNew * nnoremap Q :execute "norm i" . trim(system(""))<Left><Left><Left>
augroup END

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
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_document_highlight_enabled = 0
let g:lsp_document_code_action_signs_enabled = 0
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1

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
let g:lsp_settings_root_markers = ['package.json', '.git', '.git/']

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  "nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  "nmap <buffer> gr <plug>(lsp-references) ; Use ag search
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gr <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = 'node_modules\|\.git'
let g:ctrlp_prompt_mappings = { 'AcceptSelection("e")': [], 'AcceptSelection("t")': ['<cr>', '<c-t>'] }
