"" File: error_buffer.vim
"" Description: Create and maintain the Make error buffer
"" Version: 1.0
"" Author: ghoshs (subhagho@msn.com)
"" Namespace: vimper#project#cpp#error_buffer

setlocal nomodifiable

let s:ErrorType = ""
let s:ErrorFile = ""
let s:LastErrorLine = 0

let s:BufferName = ""

command! -n=? VmkQuit :call vimper#project#cpp#error_buffer#Quit()
command! -n=? VmkNext :call vimper#project#cpp#error_buffer#NextError(1)
command! -n=? VmkPrev :call vimper#project#cpp#error_buffer#NextError(-1)
command! -n=? VmkReop :call vimper#project#cpp#error_buffer#ReOpen()

function! vimper#project#cpp#error_buffer#ReOpen()
  let buffern = bufname(s:BufferName)
  if bufexists(buffern)
    let bufn = bufwinnr(buffern)
    if bufn < 0
      let bufn = bufnr(buffern)

      if bufn >= 0
        let l:ebSize = 40
        if exists("g:vimperErrorBufferHeight") && g:vimperErrorBufferHeight > 0
          let l:ebSize = g:vimperErrorBufferHeight
        endif
        
        execute "wincmd l"
        execute l:ebSize . "split"
        execute "wincmd j"
        execute "buffer " . s:BufferName
        call vimper#project#cpp#error_buffer#NextError(0)
      endif
    else
      execute bufn . "wincmd W"
    endif

  endif
  return
endfunction " ReOpen()

"" Show() -           Show the current error file in the buffer
"  Args :
"  	errorfile     --> Error file to show.
"  	errortype     --> Error type.
function! vimper#project#cpp#error_buffer#Build(errorfile, errortype)
  let s:ErrorType = a:errortype
  let s:ErrorFile = a:errorfile

  " clear buffer
  " setlocal modifiable | silent! normal ggdG
  " setlocal nomodifiable

  let mt = matchlist(s:ErrorFile, "[^/]*$")
  if empty(mt)
    return
  endif

  let s:BufferName = mt[0]
  let bufopened = 0

  if bufexists(bufname(s:BufferName))
    let bufn = bufwinnr(bufname(s:BufferName))
    if bufn >= 0
      execute "bdelete! " . bufname(s:BufferName)
    endif
  endif

  let l:ebSize = 40
  if exists("g:vimperErrorBufferHeight") && g:vimperErrorBufferHeight > 0
    let l:ebSize = g:vimperErrorBufferHeight
  endif

  " Load the error file
  if !bufopened
    execute "wincmd l"
    execute l:ebSize . "split"
    execute "wincmd j"
    execute "edit " . s:ErrorFile
    let bufn = bufwinnr(bufname(s:BufferName))
    if bufn >= 0
      execute bufn . "wincmd W"
    endif
    let bufopened = 1
    setlocal nomodifiable
  endif
  nnoremap <buffer> <cr>  :call vimper#project#cpp#error_buffer#OpenError()<cr>
  nnoremap <buffer> n     :call vimper#project#cpp#error_buffer#NextError(1)<cr>
  nnoremap <buffer> p     :call vimper#project#cpp#error_buffer#NextError(-1)<cr>
  nnoremap <buffer> q     :call vimper#project#cpp#error_buffer#Quit()<cr>
  
  let s:LastErrorLine = 0

  call vimper#project#cpp#error_buffer#NextError(1)
endfunction " Show()

function! s:Quit()
  au WinEnter * set nocursorline 
  au WinLeave * set nocursorline 
  set nocursorline 

  if !bufexists(bufname(s:BufferName))
    return
  endif

  let bufn = bufwinnr(bufname(s:BufferName))
  if bufn < 0
    return 0
  endif
  let s:ErrorType = ""
  let s:ErrorFile = ""
  let s:LastErrorLine = 0

  let s:BufferName = ""
 
  execute "bdelete " . bufname(s:BufferName)
endfunction "Quit()

function! vimper#project#cpp#error_buffer#NextError(direction)
  if !bufexists(bufname(s:BufferName))
    return
  endif

  let bufn = bufwinnr(bufname(s:BufferName))
  if bufn < 0
    return 0
  endif

  execute bufn . "wincmd W"
 
  let s:LastErrorLine =  s:LastErrorLine + a:direction
  while 1 == 1
    if s:LastErrorLine > line('$') || s:LastErrorLine < 0
      let s:LineErrorLine = 0
      return
    endif

    execute s:LastErrorLine 
    if vimper#project#cpp#error_buffer#OpenError() >= 0
      return
    endif

    let s:LastErrorLine =  s:LastErrorLine + a:direction
  endwhile

endfunction " NextError()

function! vimper#project#cpp#error_buffer#OpenError()
  let l:line = getline('.')
  if empty(l:line)
    return -1
  endif

  let mt = split(l:line, ":")
  if empty(mt) || len(mt) < 4
    return -1
  endif
 
  let l:etype = ""
  let l:filen = ""
  let l:linen = "0"

  if has('win32')
    if mt[0] =~ '[a-z|A-Z]'
      let l:filen = mt[0] . ":" . mt[1]
      let l:linen = mt[2]
      let l:etype = mt[3]
    else
      let l:filen = mt[0]
      let l:linen = mt[1]
      let l:etype = mt[2]
    endif
  else
      let l:filen = mt[0]
      let l:linen = mt[1]
      let l:etype = mt[2]
  endif

  if l:etype !~ "error" && l:etype !~ "warning"
    return -1
  endif
  let s:LastErrorLine = line(".")

  execute "wincmd k" 
  execute "edit " . l:filen
  execute l:linen

  au BufRead WinEnter * set nocursorline 
  au BufRead WinLeave * set cursorline 
  set cursorline 

  let bufn = bufwinnr(bufname(s:BufferName))
  if bufn < 0
    return 0
  endif

  execute bufn . "wincmd W"
  execute s:LastErrorLine

  return s:LastErrorLine
endfunction " OpenError()
