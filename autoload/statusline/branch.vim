" VCS

" Display the branch of the cwd if applicable
function! statusline#branch#Name() abort
  if &filetype =~# 'man' || &buftype =~# 'help\|quickfix\|terminal'
    return ''
  endif
  " exists('*getcmdwintype') && !empty(getcmdwintype())
  if !get(b:, 'command_window', 0) || !exists('*fugitive#head')
    return ''
  endif
  return fugitive#head(7)
endfunction
