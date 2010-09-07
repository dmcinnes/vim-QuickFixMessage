" Adds a Red or Green status message when quick fix calls pass or fail
"

function! s:CenterEcho(msg)
  let l:width = (&columns - strlen(a:msg)) / 2
  echon repeat(" ", l:width)
  echon a:msg
  echon repeat(" ", &columns - l:width - strlen(a:msg))
endfunction

function! s:AutofyQuickFix()
  let l:error = 0
  for d in getqflist()
    if d.valid
      let l:error = 1
      break
    endif
  endfor
  if l:error
    hi RedBar term=reverse ctermfg=white ctermbg=red guifg=white guibg=red
    echohl RedBar
    call CenterEcho("FAIL!")
    echohl
    cope
    au BufLeave <buffer> cclose
  else
    hi GreenBar term=reverse ctermfg=white ctermbg=green guifg=white guibg=green
    echohl GreenBar
    call CenterEcho("SUCCESS!")
    echohl
  endif
endfunction

" quickfix window goodness
augroup AUTOFYQUICKFIX
  au!
  au QuickfixCmdPost make call s:AutofyQuickFix()
  au QuickfixCmdPost grep cwindow
augroup END
