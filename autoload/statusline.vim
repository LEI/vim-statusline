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

function! statusline#QfTitle() abort
  return get(w:, 'quickfix_title', '')
endfunction

function! statusline#Hide(...) abort
  let l:bufvar = a:0 ? a:1 : ''
  " let l:buftypes = 'quickfix'
  if l:bufvar !=# '' && get(b:, l:bufvar . '_hidden', 0)
    return 1
  endif
  if l:bufvar ==# 'mode'
    if &filetype =~# g:statusline_ignore_filetypes " && !&modifiable
      return 1
    endif
  elseif l:bufvar ==# 'branch'
    if &buftype =~# g:statusline_ignore_buftypes
      return 1
    endif
  elseif l:bufvar ==# 'flags'
    if &filetype =~# g:statusline_ignore_filetypes
      return 1
    endif
    " if &filetype ==# '' && &buftype ==# 'nofile'
    "   return '' " NetrwMessage
    " endif
  " elseif l:bufvar ==# 'fileinfo'
  elseif l:bufvar ==# 'fileformat'
    if &filetype ==# '' && &buftype !=# '' && &buftype !=# 'nofile'
      return 1
    endif
    if &filetype =~# 'netrw' || &buftype =~# g:statusline_ignore_buftypes
      return 1
    endif
  endif
endfunction

" vim: et sts=2 sw=2 ts=2 foldenable foldmethod=marker
