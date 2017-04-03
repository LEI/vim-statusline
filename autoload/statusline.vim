" Status line

" Build status line
function! statusline#Build(...) abort
  let l:name = a:0 && strlen(a:1) > 0 ? a:1 : '%f'
  let l:info = a:0 > 1 ? a:2 : '' " get(g:statusline, 'right', '')
  " let l:func = get(g:, 'statusline_func', '')
  " if l:func !=# '' && exists('*' . l:func)
  "   return call(l:func, a:000)
  " endif
  if exists('g:statusline.func.left') && exists('*' . g:statusline.func.left)
    let l:left = {g:statusline.func.left}(l:name)
  else
    let l:left = '%<' . l:name . ' %h%m%r'
  endif
  if exists('g:statusline.func.right') && exists('*' . g:statusline.func.right)
    let l:right = {g:statusline.func.right}(l:info)
  else
    let l:right = l:info . '%-14.(%l,%c%V%) %P'
  endif
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
