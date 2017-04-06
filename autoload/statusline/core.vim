" Status line functions

" Get the current mode and update SatusLine highlight group
function! statusline#core#Mode(...) abort
  if &filetype =~# g:statusline_ignore_filetypes || !&modifiable
    return ''
  endif
  let l:mode =  a:0 ? a:1 :mode()
  if g:statusline.winnr != winnr() " && get(b:, 'mode_show', 0) != 1
    let l:mode = 'nc'
  endif
  return get(g:statusline.modes, l:mode, l:mode)
endfunction

" Buffer flags
function! statusline#core#Flags() abort
  if &filetype =~# g:statusline_ignore_filetypes || &buftype =~# 'terminal'
    return ''
  endif
  " if &filetype ==# '' && &buftype ==# 'nofile'
  "   return '' " NetrwMessage
  " endif
  if &buftype ==# 'help'
    return 'H'
  endif
  let l:flags = []
  if &previewwindow
    call add(l:flags, 'PRV')
  endif
  if &readonly
    call add(l:flags, 'RO')
  endif
  if &modified
    call add(l:flags, '+')
  elseif !&modifiable
    call add(l:flags, '-')
  endif
  return join(l:flags, ',')
endfunction

" File or buffer type
function! statusline#core#Type() abort
  if &filetype ==# ''
    if &buftype !=# 'nofile'
      return &buftype
    endif
    return ''
  endif
  if &filetype ==# 'netrw' && get(b:, 'netrw_browser_active', 0) == 1
    let l:netrw_direction = (g:netrw_sort_direction =~# 'n' ? '+' : '-')
    return &filetype . '[' . g:netrw_sort_by . l:netrw_direction . ']'
  endif
  " if &filetype ==# 'qf'
  "   return &buftype " quickfix
  " endif
  return &filetype
endfunction

" File encoding and format
function! statusline#core#Format() abort
  if &filetype ==# '' && &buftype !=# '' && &buftype !=# 'nofile'
    return ''
  endif
  if &filetype =~# 'netrw' || &buftype =~# 'help\|quickfix'
    return ''
  endif
  if strlen(&fileencoding) > 0
    let l:enc = &fileencoding
  else
    let l:enc = &encoding
  endif
  if exists('+bomb') && &bomb
    let l:enc.= '-bom'
  endif
  if l:enc ==# 'utf-8'
    let l:enc = ''
  endif
  if &fileformat !=# 'unix'
    let l:enc.= '[' . &fileformat . ']'
  endif
  return l:enc
endfunction
