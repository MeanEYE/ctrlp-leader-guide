if v:version < 700 || &cp
  finish
endif

call add(g:ctrlp_ext_vars, {
  \ 'init': 'ctrlp#key#init()',
  \ 'accept': 'ctrlp#key#accept',
  \ 'lname': 'leader-guide',
  \ 'sname': '',
  \ 'type': 'line',
  \ 'sort': 0,
  \ 'specinput': 0,
  \ })

let s:fml_leader = exists('mapleader') ? mapleader : '\'
if(s:fml_leader == ' ')
  let s:fml_leader = '<Space>'
endif
let s:fml_escaped_leader = escape(s:fml_leader, '\')

function! ctrlp#key#FMLGetLeaderMappingsBySource() abort
  let all_maps = ''
  let old_lang = v:lang
  lang message C
  redir => all_maps
  silent execute 'verbose map'
  redir END
  silent execute 'lang message' old_lang
  let lines = split(all_maps, "\n")
  let linesLen = len(lines)
  let mappings_by_source = {}
  let idx = 0
  while idx < linesLen
    let mapping = lines[idx] 
    if(mapping =~? '\V\^\(\a\| \)\s\+' . s:fml_escaped_leader . '\S')
      let source = split(lines[idx + 1], 'from ')[1] 
      let is_vimrc = ctrlp#key#FMLIsVimrc(source)
      if(g:fml_all_sources || is_vimrc)
        let mappings = get(mappings_by_source, source, [])
        let mappings_by_source[source] = add(mappings, ctrlp#key#FMLParseMapping(mapping))
      endif
    endif
    let idx = idx + 2
  endwhile
  let with_desc = map(mappings_by_source, 'ctrlp#key#FMLAddDescription(v:key, reverse(v:val))')
  if(exists("s:vimrc_glob"))
    let vimrc_val = remove(with_desc, s:vimrc_glob)
    let vimrc_first = [{ 'source': s:vimrc_glob, 'mappings': vimrc_val }]
  else
    let vimrc_first = []
  endif
  let vimrc_first += values(map(with_desc, '{ "source": v:key, "mappings": v:val }'))
  return vimrc_first
endfunction


function! ctrlp#key#FMLIsVimrc(src_glob) abort
  if(exists("s:vimrc_glob"))
    return s:vimrc_glob == a:src_glob
  elseif(glob(a:src_glob) == $MYVIMRC)
    let s:vimrc_glob = a:src_glob
    return 1
  else
    return 0
  endif
endfunction

function! ctrlp#key#FMLParseMapping(mapping_line)
  let pattern = '\V\^\(\a\| \)\s\+' . s:fml_escaped_leader . '\(\S\+\)\s\+\%(*\| \)\%(@\| \)\(\.\+\)'
  let groups = matchlist(a:mapping_line, pattern)
  return { 'id': substitute(groups[1] . '_' . groups[2], ' ', '', ''), 'mode': groups[1], 'lhs': groups[2], 'rhs': groups[3] }
endfunction

function! ctrlp#key#FMLAddDescription(src, mappings)
  let src_lines = readfile(glob(a:src))
  let lines_with_index = map(deepcopy(src_lines), '[v:key, v:val]') 
  let comments_by_id = {}
  for [idx, line] in lines_with_index
    let lhs = matchlist(line, '\c\m^\(\a\?\)\a*map.*<leader>\(\S\+\)')
    if(!empty(lhs))
      let prev_line = src_lines[idx - 1]
      let comment = matchlist(prev_line, '^"\s*\(.*\)')
      if(!empty(comment))
        let comments_by_id[lhs[1] . '_' . lhs[2]] = comment[1]
      endif
    endif
  endfor
  return map(a:mappings, 'has_key(comments_by_id, v:val.id) ? extend(v:val, {"desc": comments_by_id[v:val.id]}) : v:val')
endfunction

function! ctrlp#key#FMLFormatMappings(source, mappings)
  let mapping_width = ctrlp#key#FMLCalcMappingWidth(a:mappings)
  let formatted = map(a:mappings, 'printf(" %-' . mapping_width . 's | %s ", v:val.lhs,get(v:val, "desc", v:val.rhs))')
  return join(formatted, "\n")
endfunction

function! ctrlp#key#FMLCalcMappingWidth(mappings)
  let mapping_width = 1
  for val in a:mappings
    let mapping_width = max([mapping_width, strlen(val.lhs)])
  endfor
  return mapping_width
endfunction

function! ctrlp#key#init() abort
    let formattedMappings = join(map(ctrlp#key#FMLGetLeaderMappingsBySource(), 'ctrlp#key#FMLFormatMappings(v:val.source, v:val.mappings)'),"\n\n")
    let l:text=split(formattedMappings,'\n')
    return l:text
endfunction

function! ctrlp#key#accept(mode, str) abort
  call ctrlp#exit()
  let l:key=matchstr(a:str,'\w\+\(\s\+|\)\@=')
  let l:key = maparg(s:fml_leader.l:key)
  if matchstr(l:key,'\c^:\|<cr>') !=# ''
    execute substitute(l:key,'\c<cr>','|','g')
  else
    let l:temp=eval('"'.escape(l:key,'<').'"')
    call feedkeys(l:temp)
  endif
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#key#id() abort
  return s:id
endfunction

" vim:nofen:fdl=0:ts=2:sw=2:sts=2
