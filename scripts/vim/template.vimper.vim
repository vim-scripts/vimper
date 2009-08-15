" Description: Templates for creating the Vim Project load configuration.
" Maintainer:  SubhaGho
" Last Change: 3 aug. 2009

" Keep only one window open
execute "wincmd o" 
execute "bdelete"
let s:wSize = 40
if exists("g:vimperExplorerWidth") && g:vimperExplorerWidth
  let s:wSize = g:vimperExplorerWidth
endif
execute s:wSize . "vsp"
execute "wincmd h"

let proj_root = <PROJ_HOME>

execute "cd " . proj_root

execute "VTreeExplore " . proj_root
