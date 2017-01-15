if(!exists("g:fml_all_sources"))
  let g:fml_all_sources=0
endif


function! FMLShow()
    :call ctrlp#init(ctrlp#key#id()) 
endfunction

nnoremap <silent> <Plug>(FollowMyLead) :call FMLShow()<CR>

" Open Leader mappings in new window
nmap <Leader>hk <Plug>(FollowMyLead)
nmap <Leader>? <Plug>(FollowMyLead)
