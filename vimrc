let g:pathogen_disabled = []

" store temporary files in /tmp, not in network home (bye, bye security...)
call system("mkdir -p /tmp/.schulzh")
call system("chown schulzh:User6SBStaff /tmp/.schulzh")
call system("chmod go-rwx /tmp/.schulzh")
let g:yankring_history_dir = '/tmp/.schulzh'
set directory=/tmp/.schulzh

" omni-completion conflicts with clang completion
call add(g:pathogen_disabled, 'syntastic')
"au BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main
"au BufNewFile,BufRead,BufEnter *.cu,*.cuh  set omnifunc=omni#cpp#complete#Main

" this must come _before_ filetype detection
call pathogen#infect()

syntax on
filetype plugin indent on

set pastetoggle=<C-'>
call togglebg#map("<F5>")

se bg=dark
colorscheme solarized

set nocompatible
se nowrap
se diffopt=iwhite,filler,icase
se ssop="curdir,folds,options,tabpages,winsize"
set incsearch
set smartcase

set spelllang=de,en

set sw=4
set ts=4
set et
set hls

ab bp import pdb ; pdb.set_trace()

let g:load_doxygen_syntax=1
let g:doxygen_enhanced_colour=1

filetype off
filetype plugin indent on

set wildmenu
set wildmode=longest,full
nmap . .`[

"let g:syntastic_enable_signs=1
let loaded_cpp_syntax_checker = 1
let g:syntastic_cpp_check_header = 1
let g:syntastic_auto_loc_list=1

" always keep a statusline
set laststatus=2

" lets see whether that works out.
imap jj <Esc>

" write files for which we do not have rights by using sudo to copy a tmp-file
cmap w!! %!sudo tee > /dev/null %

" restore visual mode selection after indenting
vmap < <gv
vmap > >gv

" show the (partial) command in last line of screen, turn off for slow
" terminals
set showcmd

" completion: show more infos
set showfulltag

let g:autodate_keyword_pre = '__version__ = '
let g:autodate_keyword_post = ''

"augroup MyIMAPs
    "au!
    "au VimEnter * call IMAP('FRA', '\begin{frame}'."\<CR>".'{'."\<CR>".'\frametitle{<+title+>}'."\<CR>".'<+content+>'."\<CR>\<CR>".'}<++>', 'tex')
    "au VimEnter * call IMAP('BLO', '\begin{block}{<++>}'."\<CR>".'<++>'."\<CR>\<CR>".'\end{block}<++>', 'tex')
"augroup END

map Q mxgqip`x
"map T :TlistToggle<CR>
nnoremap <silent> T :TagbarToggle<CR>

" Alternate
let g:alternateExtensions_h = "c,cpp,cxx,cc,CC,cu"
let g:alternateExtensions_hpp = "c,cpp,cxx,cc,CC,cu"
let g:alternateExtensions_cu  = "h,hpp,H"
let mapleader = ","

" CTAGS
map <Leader>C :!ctags --sort=foldcase -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" Popup Colors
hi Pmenu ctermfg=0 ctermbg=7
hi PmenuSel ctermfg=7 ctermbg=4
hi PmenuSbar ctermfg=0 ctermbg=4
hi PmenuThumb gui=reverse

" Filetypes
au BufEnter *.cu  set ft=cuda
au BufEnter *.cuh set ft=cuda
au BufNewFile,BufRead *.py,*pyw set filetype=python
au FileType python setlocal omnifunc=pythoncomplete#Complete
au FileType python let python_highlight_all=1
au FileType python let python_print_as_function=1
au FileType python syn keyword pythonStatement class nextgroup=pythonClass skipwhite
au FileType python syn match pythonClass "[a-zA-Z_][a-zA-Z0-9_]*" display contained
au FileType python hi link pythonClass Type
au FileType mail   setlocal fo+=v " do not break long lines when they already were long at start of insert mode
let g:NERDShutUp=1

" requires vim-python and python-git
function! CommitFile()
python << EOF
import vim, git
curfile = vim.current.buffer.name
if curfile:
    try:
        repo = git.Repo(curfile)
        repo.git.add(curfile)
        repo.git.commit(m='Automatic Update: File saved.')
        i = os.popen("ifconfig eth0 | grep inet | awk '{print $2}' | sed -e s/.*://", "r").read()
        if i.startswith('10.7.7.231'): os.popen("cd `dirname %s` ; git push bigcuda1 master 2>&1 > /dev/null" % curfile).read()
    except (git.InvalidGitRepositoryError, git.GitCommandError):
        pass
EOF
endfunction
au BufWritePost *.wiki call CommitFile()
let g:vimwiki_folding=1
let g:vimwiki_fold_lists=1


" Python
let $PYTHONPATH .= ":~/.vim/ropevim-0.3-rc"
let ropevim_vim_completion=1
let ropevim_extended_complete=1
let g:ropevim_autoimport_modules = ["os", "sys", "pdb"]
se nocompatible

" XPT
let g:xptemplate_vars="$SParg=&$author=Hannes Schulz&$email=<schulz at ais dot uni-bonn dot de>"
let g:xptemplate_key = '<Tab>'
let g:xptemplate_brace_complete=1
let g:xptemplate_brace_complete = '([{'
au FileType tex let g:xptemplate_key = '<C-r>'


" Gundo requires at least vim 7.3
if v:version >= '703'
	"undo persistence
	set undofile
	set undodir=/tmp/.schulzh/undos

	"conceiling
	set cole=2
	hi Conceal guibg=white guifg=black
	let g:tex_conceal="adgm"
    syn match texMathSymbol '\\w\>' contained conceal
endif

" quit if only quickfix window left
let s:cpo_save = &cpo
set cpo&vim
augroup plugin-now-quit-if-only-quickfix-buffer-left
  autocmd!
  autocmd WinEnter * if winnr('$') == 1 && &buftype == 'quickfix' | quit | endif
augroup end
let &cpo = s:cpo_save
unlet s:cpo_save

" 256 color support
set t_Co=256
"set t_AB=^[[48;5;%dm
"set t_AF=^[[38;5;%dm
"set bg=light
"colorscheme bandit

" clang completion
"let g:clang_user_options=' -U__GXX_EXPERIMENTAL_CXX0X__ -I. -I /usr/local/cuda/include -I /usr/include/opencv-2.3.1 -I ~/checkout/git/mongo/include  -std=gnu++0x || exit 0'
let g:clang_hl_errors=0
let g:clang_complete_auto=1
let g:clang_complete_copen=1
let g:clang_snippets=0
let g:clang_debug=1
let g:clang_use_library=0

let g:syntastic_cpp_params='-std=gnu++0x -I . -I ~/pool/include/boost-numeric-bindings -I/home/local/cuv/src -I/usr/include/qt4  -I/usr/include/qt4/QtGui -I../build/src/ui -Wno-deprecated -I ~/checkout/git/mongo/include '

let c_no_curly_error=1

"ledger
let g:ledger_fillstring = '˙'
let g:ledger_detailed_first = 1
au FileType ledger noremap <silent><buffer> <C-C><C-A> :call LedgerSetDate(line('.'),'actual')<CR>
au FileType ledger hi Folded ctermbg=white guibg=white
let g:ledger_maxwidth = 65


"changes plugin
":let g:changes_verbose=0
":let g:changes_autocmd=1
":let g:changes_hl_lines=1

" mail
au FileType mail setlocal fo=tcrqn ai com=n:>,fb:-,fb:* tw=65

" perl
let g:xptemplate_brace_complete=0

" intelliTags
let g:Itags_Depth = 2

" google scribe
au filetype gitcommit setl completefunc=googlescribe#Complete
au filetype tex       setl completefunc=googlescribe#Complete

" csv
hi CSVColumnEven term=bold ctermbg=4 guibg=DarkBlue
hi CSVColumnOdd  term=bold ctermbg=7 guibg=DarkMagenta

""""""""""""""""""""""""""""""""""""
" ctrl-p
let g:ctrlp_map = '<c-x><c-b>'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']
set wildignore+=*/.svn/*,*.so,*/boost/*,*/.mk/*,*/.git/*,*/boost_1_45_0/*

"0 - don't manage working directory.
"1 - the parent directory of the current file.
"2 - the nearest ancestor that contains one of these directories or files: 
".git/ .hg/ .bzr/ _darcs/ root.dir .vimprojects
let g:ctrlp_working_path_mode = 0
let g:ctrlp_max_files = 1000
let g:ctrlp_max_depth = 8

""""""""""""""""""""""""""""""""""""
" PowerLine
let g:Powerline_symbols='fancy'
let g:Powerline_colorscheme = 'solarized256'

""""""""""""""""""""""""""""""""""""
" Vimux
" Prompt for a command to run
map <Leader>rp :PromptVimTmuxCommand<CR>
" Run last command executed by RunVimTmuxCommand
map <Leader>rl :RunLastVimTmuxCommand<CR>
" Inspect runner pane
map <Leader>ri :InspectVimTmuxRunner<CR>
" Close all other tmux panes in current window
map <Leader>rx :CloseVimTmuxPanes<CR>
" Interrupt any command running in the runner pane
map <Leader>rs :InterruptVimTmuxRunner<CR>

""""""""""""""""""""""""""""""""""""
" vim-g
let g:vim_g_open_command = "www-browser"

""""""""""""""""""""""""""""""""""""
" source explorer
"nmap <F8> :SrcExplToggle<CR> 
"let g:SrcExpl_updateTagsCmd = "ctags --sort=foldcase -R --c++-kinds=+p --fields=+iaS --extra=+q ."
"let g:SrcExpl_pluginList = [ 
"     \ "__Tag_List__", 
"     \ "_NERD_tree_", 
"     \ "Source_Explorer" 
"     \ ] 
"let g:SrcExpl_isUpdateTags = 0
"let g:SrcExpl_gobackKey = "<SPACE>" 
"let g:SrcExpl_refreshTime = 100


" fix urxvt: scroll through buffers with ctrl-pageup/down
nmap    <ESC>[5^    <C-PageUp>
nmap    <ESC>[6^    <C-PageDown>
nnoremap <C-PageDown> :bn!<CR>
nnoremap <C-PageUp> :bp!<CR>

nmap <Esc>Oc <C-Right>
nmap <Esc>Od <C-Left>
nmap <Esc>Ob <C-Down>
nmap <Esc>Oa <C-Up>

