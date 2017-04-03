" Status line

if get(g:, 'loaded_statusline', 0) || v:version < 700 || &compatible
  finish
endif
let g:loaded_statusline = 1

" let s:save_cpo = &cpo
" set cpo&vim

" if has('autocmd') && !exists('#statusline')
"   augroup statusline
"     autocmd!

"     " Redraw the status line of the current window
"     autocmd InsertLeave * redrawstatus
"     "autocmd InsertLeave * call statusline#update()
"     "autocmd BufWinEnter,BufWinLeave * call statusline#update()

"     autocmd BufAdd,BufEnter,WinEnter * call statusline#update()
"     "autocmd BufLeave,WinLeave * call statusline#update(1)
"     "autocmd WinEnter,BufWinEnter,FileType,ColorScheme,SessionLoadPost * call statusline#update()

"     "autocmd TabEnter * echom 'TabEnter'
"     "autocmd TabLeave * echom 'TabLeave'
"     "autocmd VimResized * call statusline#update()

"     autocmd ColorScheme * call statusline#colorscheme()
"     "autocmd VimEnter * call statusline#template()

"     " autocmd CmdwinEnter * let &l:statusline=' %#StatusLineMode#%{statusline#core#mode("cl")} %#StatusLineNC# %<COMMAND LINE %h%m%r %#StatusLineNC#%=%5.(%p%%%)%4.(%l%):%-4.(%c%V%)'
"     autocmd CmdwinEnter * call statusline#update()
"     autocmd CmdwinLeave * call statusline#update(winnr() - 1)

"     "autocmd CmdwinEnter * call statusline#update({ 'branch': 0, 'encoding': 0, 'format': 0 })
"     "autocmd CmdwinLeave * call statusline#unset()

"     " getcmdwintype()
"     " The character used for the pattern indicates the type of command-line:
"     "  :: normal Ex command
"     "  >: debug mode command |debug-mode|
"     "  /: forward search string
"     "  ?: backward search string
"     "  =: expression for "= |expr-register|
"     "  @: string for |input()|
"     "  -: text for |:insert| or |:append|
"   augroup END
" endif

" let &cpo = s:save_cpo
" unlet s:save_cpo


" set statusline=%!statusline#Build()

let g:statusline_ignore_buftypes = 'help\|quickfix'
let g:statusline_ignore_filetypes = 'dirvish\|netrw\|taglist\|qf\|vim-plug'

let s:save_cpo = &cpoptions
set cpoptions&vim

let g:statusline = get(g:, 'statusline', {})
call extend(g:statusline, {'func': {}, 'modes': {}, 'symbols': {}}, 'keep')

" Active window number
let g:statusline.winnr = winnr()

" Format Markers: {{{
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
" }}}

" Modes: {{{
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
" }}}

" Symbols: {{{ (key: 0x1F511)
let s:c = has('multi_byte') && &encoding ==# 'utf-8'
call extend(g:statusline.symbols, {
      \   'key': s:c ? nr2char(0x1F511) : '$',
      \   'sep': s:c ? ' ' . nr2char(0x2502) . ' ' : ' ',
      \   'lock': s:c ? nr2char(0x1F512) : '@',
      \   'nl': s:c ? nr2char(0x2424) : '\n',
      \   'ws': s:c ? nr2char(0x39E) : '\s',
      \ }, 'keep')
" }}}

" Highlight Groups: {{{
highlight link StatusLineReverse StatusLine
highlight link StatusLineInsert StatusLine
highlight link StatusLineReplace StatusLine
highlight link StatusLineVisual StatusLine
" highlight link StatusLineBranch StatusLine
highlight link StatusLineError ErrorMsg
highlight link StatusLineWarn WarningMsg
" }}}

" " v:vim_did_enter |!has('vim_starting')
" let s:enable = get(g:, 'statusline#enable_at_startup', 1)
" if s:enable
"   call statusline#Colors()
"   " call statusline#ctrlp#Enable()
" endif

augroup StatusGroup
  autocmd!
  " autocmd ColorScheme * call statusline#Colors()
  autocmd InsertEnter * call statusline#core#highlight(v:insertmode)
  autocmd InsertChange * call statusline#core#highlight(v:insertmode)
  autocmd InsertLeave * call statusline#core#highlight()

  " autocmd WinEnter,FileType,BufWinEnter * let &l:statusline = statusline#Build()
  autocmd BufAdd,BufEnter,WinEnter * let g:statusline.winnr = winnr()

  " Update whitespace warnings (add InsertLeave?)
  autocmd BufWritePost,CursorHold * unlet! b:statusline_indent | unlet! b:statusline_trailing

  autocmd CmdWinEnter * let g:statusline.winnr = winnr() | let b:branch_hidden = 1
        \ | let &l:statusline = statusline#Build('Command Line')
  autocmd CmdWinLeave * let g:statusline.winnr = winnr() - 1

  " FIXME autocmd QuickFixCmdPost
  autocmd FileType qf let &l:statusline = statusline#Build('%f%( %{statusline#QfTitle()}%)')
  autocmd FileType taglist let &l:statusline = statusline#Build(s:replace_(expand('%')))
  autocmd FileType vim-plug let &l:statusline = statusline#Build('Plugins')
augroup END

function! s:replace_(string) abort
  let l:str = a:string
  if matchstr(l:str, '__.*__') ==# ''
    return l:str
  endif
  let l:str = substitute(l:str, '__', '', 'g')
  let l:str = substitute(l:str, '_', ' ', 'g')
  return l:str
endfunction

" Default: %<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
command! -nargs=* -bar CursorStl let &g:statusline = statusline#Build('%f', '%([%b 0x%B]%)')

let &cpoptions = s:save_cpo
unlet s:save_cpo

" vim: et sts=2 sw=2 ts=2 foldenable foldmethod=marker
