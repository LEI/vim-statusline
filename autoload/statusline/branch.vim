" VCS

" Display the branch of the cwd if applicable
function! statusline#branch#Name() abort
  if !exists('*fugitive#head') || statusline#Hide('branch')
    return ''
  endif
  return fugitive#head(7)
endfunction
