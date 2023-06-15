func! AutoHoverHighlightInit()
  if !exists('g:autoHoverHighlightenable')
    let g:autoHoverHighlightenable = 1  " 默认打开 hover 高亮
  end
  if g:AutoHoverHighlightToggle != ''
    " use <expr> to ensure showing the status when toggle
    execute 'inoremap <buffer> <silent> <expr> '.g:AutoHoverHighlightToggle.' AutoHoverHighlightToggle()'
    execute 'noremap <buffer> <silent> '.g:AutoHoverHighlightToggle.' :call AutoHoverHighlightToggle()<CR>'
end
endf


func! AutoHoverHighlightToggle()
  if g:autoHoverHighlightenable
    let g:autoHoverHighlightenable = 0
    echo 'AutoHoverHighlight Disabled.'
  else
    let g:autoHoverHighlightenable = 1
    echo 'AutoHoverHighlight Enabled.'
  end
  return ''
endf

if !exists('g:AutoHoverHighlightToggle')
  let g:AutoHoverHighlightToggle = '<M-h>'
end

au BufEnter * :call AutoHoverHighlightInit()


function! HighlightWordUnderCursor()
    if !(g:autoHoverHighlightenable)
        return
    end
    let disabled_ft = ["qf", "fugitive", "nerdtree", "gundo", "diff", "fzf", "floaterm"]
    if &diff || &buftype == "terminal" || index(disabled_ft, &filetype) >= 0
        return
    endif
    if getline(".")[col(".")-1] !~# '[[:punct:][:blank:]]'
        hi MatchWord cterm=undercurl gui=undercurl guibg=#3b404a
        exec 'match' 'MatchWord' '/\V\<'.expand('<cword>').'\>/'
    else
        match none
    endif
endfunction

augroup MatchWord
  autocmd!
  autocmd! CursorHold,CursorHoldI * call HighlightWordUnderCursor()
augroup END
