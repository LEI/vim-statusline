" Whitespace warnings

function! s:MixedIndent()
  " Find spaces that arent used as alignment in the first indent column
  " let l:et = &expandtab ? 'spaces' : 'tabs' " &et / &noet
  " let l:s = search('^ \{' . &tabstop . ',}[^\t]', 'nw')
  let l:s = search('^ ', 'nw')
  let l:t = search('^\t', 'nw')
  if l:s != 0 && l:t != 0
    return printf('mixed[%s]', &expandtab ? l:t : l:s)
  elseif l:s != 0 && !&expandtab
    return printf('&noet[%s]', l:s)
  elseif l:t != 0 && &expandtab
    return printf('&et[%s]', l:t)
  endif
  return ''
endfunction

" Indentation warning
function! statusline#warn#Indent() abort
  if !&modifiable || &paste " Ignore &et warnings in paste mode
    return ''
  endif
  if !exists('b:statusline_indent')
    let b:statusline_indent = s:MixedIndent()
  endif
  return b:statusline_indent
endfunction

" Trailing whitespaces
function! statusline#warn#Trailing() abort
  if !&modifiable
    return ''
  endif
  if !exists('b:statusline_trailing')
    let l:s = search('\s\+$', 'nw')
    let b:statusline_trailing =  l:s != 0 ? 'trailing' . printf('[%s]', l:s) : ''
  endif
  return b:statusline_trailing
endfunction
