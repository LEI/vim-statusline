" Status line

function! statusline#Get(...) abort
  let l:key = a:0 ? a:1 : ''
  let l:args = a:0 > 1 ? a:2 : []
  let l:default = a:0 > 2 ? a:3 : ''
  let l:str = l:default
  if !exists('g:statusline.' . l:key)
    return l:str
  endif
  " Function reference, function name or string
  if exists('*g:statusline.' . l:key) || exists('*g:' . g:statusline[l:key])
    let l:str = call(g:statusline[l:key], l:args)
  elseif !empty(g:statusline[l:key])
    let l:str = g:statusline[l:key]
  endif
  return l:str
endfunction

" Build status line
function! statusline#Build(...) abort
  let l:name = a:0 && strlen(a:1) > 0 ? a:1 : '%f'
  let l:info = a:0 > 1 ? a:2 : '' " get(g:statusline, 'right', '')
  let l:left = statusline#Get('left', [l:name], '%<' . l:name . ' %h%m%r')
  let l:right = statusline#Get('right', [l:info], l:info . '%-14.(%l,%c%V%) %P')
  return l:left . '%=' . l:right
endfunction

" Change status line highlight groups
function! statusline#Highlight(...) abort
  let l:im = a:0 ? a:1 : ''
  " let l:im = a:0 ? a:1 : v:insertmode
  if l:im ==# 'i' " Insert mode
    highlight! link StatusLine StatusLineInsert
  elseif l:im ==# 'r' " Replace mode
    highlight! link StatusLine StatusLineReplace
  elseif l:im ==# 'v' " Virtual replace mode
    highlight! link StatusLine StatusLineReplace
  elseif strlen(l:im) > 0
    echoerr 'Unknown mode: ' . l:im
  else
    highlight link StatusLine NONE
  endif
  " let l:mode = mode()
  " if l:mode ==# 'n'
  "   highlight! link StatusLine StatusLineNormal
  " elseif l:mode ==# 'i'
  "   highlight! link StatusLine StatusLineInsert
  " elseif l:mode ==# 'R'
  "   highlight! link StatusLine StatusLineReplace
  " elseif l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# '^V'
  "   highlight! link StatusLine StatusLineVisual
  " endif
endfunction

function! statusline#QfTitle() abort
  return get(w:, 'quickfix_title', '')
endfunction

" vim: et sts=2 sw=2 ts=2 foldenable foldmethod=marker
