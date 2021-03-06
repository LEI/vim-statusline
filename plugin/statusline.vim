" Status line

if !has('autocmd') || !has('statusline')
  finish
endif

if get(g:, 'loaded_statusline', 0) || v:version < 700 || &compatible
  finish
endif

let g:loaded_statusline = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

" set statusline=%!statusline#Build() | set noshowmode

" Format Markers: {{{1

" Default: %<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
" %< Where to truncate line if too long
" %n Buffer number
" %F Full path to the file in the buffed
" %f Relative path or as typed
" %t File name (tail)
" %m Modified flag [+] (modified), [-] (unmodifiable) or nothing
" %r Readonly flag [RO]
" %w Preview window flag
" %y Filetype [ruby]
" %= Separation point between left and right aligned items
" %l Current line number
" %L Number of lines in buffer
" %c Current column number
" %V Current virtual column number (-n), if different from %c
" %P Percentage through file of displayed window
" %( Start of item group (%-35. width and alignement of a section)
" %) End of item group

" Variables: {{{1

" Hide mode and flags under these file types
let g:statusline_ignore_filetypes = 'dirvish\|man\|netrw\|taglist\|qf\|vim-plug'

let g:statusline = get(g:, 'statusline', {})
call extend(g:statusline, {'func': {}, 'modes': {}, 'symbols': {}}, 'keep')

" Active window number
let g:statusline.winnr = winnr()

" Modes: {{{1
" n       Normal
" no      Operator-pending
" v       Visual by character
" V       Visual by line
" CTRL-V  Visual blockwise
" s       Select by character
" S       Select by line
" CTRL-S  Select blockwise
" i       Insert
" R       Replace |R|
" Rv      Virtual Replace |gR|
" c       Command-line
" cv      Vim Ex mode |gQ|
" ce      Normal Ex mode |Q|
" r       Hit-enter prompt
" rm      The -- more -- prompt
" r?      A confirm query of some sort
" !       Shell or external command is executing

call extend(g:statusline.modes, {
      \   'nc': '------',
      \   'n': 'NORMAL',
      \   'i': 'INSERT',
      \   'R': 'REPLACE',
      \   'v': 'VISUAL',
      \   'V': 'V-LINE',
      \   'c': 'COMMAND',
      \   '': 'V-BLOCK',
      \   's': 'SELECT',
      \   'S': 'S-LINE',
      \   '': 'S-BLOCK',
      \   't': 'TERMINAL',
      \ }, 'keep')

" Symbols: {{{1
" key: 0x1F511

let s:c = has('multi_byte') && &encoding ==# 'utf-8'
call extend(g:statusline.symbols, {
      \   'key': s:c ? nr2char(0x1F511) : '$',
      \   'sep': s:c ? ' ' . nr2char(0x2502) . ' ' : ' ',
      \   'lock': s:c ? nr2char(0x1F512) : '@',
      \   'nl': s:c ? nr2char(0x2424) : '\n',
      \   'ws': s:c ? nr2char(0x39E) : '\s',
      \ }, 'keep')

" Highlight Groups: {{{1

highlight link StatusLineReverse StatusLine
highlight link StatusLineInsert StatusLine
highlight link StatusLineReplace StatusLine
highlight link StatusLineVisual StatusLine
" highlight link StatusLineBranch StatusLine
highlight link StatusLineError ErrorMsg
highlight link StatusLineWarn WarningMsg

" Functions: {{{1

function! s:Replace_(string) abort
  let l:str = a:string
  if matchstr(l:str, '__.*__') ==# ''
    return l:str
  endif
  let l:str = substitute(l:str, '__', '', 'g')
  let l:str = substitute(l:str, '_', ' ', 'g')
  return l:str
endfunction

" Auto Commands: {{{1

augroup StatusGroup
  autocmd!
  " autocmd ColorScheme * call statusline#Colors()
  autocmd InsertEnter * call statusline#Highlight(v:insertmode)
  autocmd InsertChange * call statusline#Highlight(v:insertmode)
  autocmd InsertLeave * call statusline#Highlight()

  " autocmd WinEnter,FileType,BufWinEnter * let &l:statusline = statusline#Build()
  autocmd BufAdd,BufEnter,WinEnter * let g:statusline.winnr = winnr()

  " Update whitespace warnings (add InsertLeave?)
  autocmd BufWritePost,CursorHold * unlet! b:statusline_indent | unlet! b:statusline_trailing

  autocmd CmdWinEnter * let g:statusline.winnr = winnr()
        \ | let b:command_window = 1
        \ | let &l:statusline = statusline#Build('Command Line')
  autocmd CmdWinLeave * let g:statusline.winnr = winnr() - 1
        \ | unlet b:command_window
  " getcmdwintype()
  " The character used for the pattern indicates the type of command-line:
  "  :: normal Ex command
  "  >: debug mode command |debug-mode|
  "  /: forward search string
  "  ?: backward search string
  "  =: expression for "= |expr-register|
  "  @: string for |input()|
  "  -: text for |:insert| or |:append|

  " FIXME autocmd QuickFixCmdPost
  autocmd FileType qf let &l:statusline = statusline#Build('%f%( %{statusline#QfTitle()}%)')
  autocmd FileType taglist let &l:statusline = statusline#Build(s:Replace_(expand('%')))
  autocmd FileType vim-plug let &l:statusline = statusline#Build('Plugins')
augroup END

" Commands: {{{1

command! -nargs=* -bar StatusLineBuild let &g:statusline = statusline#Build()
command! -nargs=* -bar StatusLineCursor let &g:statusline = statusline#Build('%f', '%([%b 0x%B]%)')

" 1}}}

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim: et sts=2 sw=2 ts=2 foldenable foldmethod=marker
