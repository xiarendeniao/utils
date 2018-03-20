set tabstop=4

"调用shell的gr命令
:map gr :!gr <cword> <CR>

"调用shell的gr命令，需要回车才执行，会车前可以自行补充目录信息
:map gr1 :!gr <cword> 
:map gr1 :!gr <cword> ./server

"用tt切换到上一次的tab页面
auto tableave * let g:pre_tabpagenr=tabpagenr()
nnoremap <silent> tt :exe "tabn ".g:pre_tabpagenr<CR> 


"状态栏
set laststatus=2      " 总是显示状态栏 
"highlight StatusLine cterm=bold ctermfg=yellow ctermbg=blue
" 获取当前路径，将$HOME转化为~  
function! CurDir()  
    let curdir = substitute(getcwd(), $HOME, "~", "g")  
    return curdir  
endfunction  
"set statusline=[%n]\ %f%m%r%h\ \|\ \ pwd:\ %{CurDir()}\ \ \|%=\|\ %l,%c\ %p%%\ \|\ ascii=%b,hex=%b%{((&fenc==\"\")?\"\":\"\ \|\ \".&fenc)}\ \|\ %{$USER}\ @\ %{hostname()}\ 
"set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%] "显示文件名：总行数，总的字符数  
"set ruler "在编辑过程中，在右下角显示光标位置的状态行 

"显示tab页的编号
set tabline=%!MyTabLine()  " custom tab pages line  
function MyTabLine()  
    let s = '' " complete tabline goes here  
    " loop through each tab page  
    for t in range(tabpagenr('$'))  
        " set highlight  
        if t + 1 == tabpagenr()  
            let s .= '%#TabLineSel#'  
        else  
            let s .= '%#TabLine#'  
        endif  
        " set the tab page number (for mouse clicks)  
        let s .= '%' . (t + 1) . 'T'  
        let s .= ' '  
        " set page number string  
        let s .= t + 1 . ' '  
        " get buffer names and statuses  
        let n = ''      "temp string for buffer names while we loop and check buftype  
        let m = 0       " &modified counter  
        let bc = len(tabpagebuflist(t + 1))     "counter to avoid last ' '  
        " loop through each buffer in a tab  
        for b in tabpagebuflist(t + 1)  
            " buffer types: quickfix gets a [Q], help gets [H]{base fname}  
            " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname  
            if getbufvar( b, "&buftype" ) == 'help'  
                let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )  
            elseif getbufvar( b, "&buftype" ) == 'quickfix'  
                let n .= '[Q]'  
            else  
                let n .= pathshorten(bufname(b))  
            endif  
            " check and ++ tab's &modified count  
            if getbufvar( b, "&modified" )  
                let m += 1  
            endif  
            " no final ' ' added...formatting looks better done later  
            if bc > 1  
                let n .= ' '  
            endif  
            let bc -= 1  
        endfor  
        " add modified label [n+] where n pages in tab are modified  
        if m > 0  
            let s .= '[' . m . '+]'  
        endif  
        " select the highlighting for the buffer names  
        " my default highlighting only underlines the active tab  
        " buffer names.  
        if t + 1 == tabpagenr()  
            let s .= '%#TabLineSel#'  
        else  
            let s .= '%#TabLine#'  
        endif  
        " add buffer names  
        if n == ''  
            let s.= '[New]'  
        else  
            let s .= n  
        endif  
        " switch to no underlining and add final space to buffer list  
        let s .= ' '  
    endfor  
    " after the last tab fill with TabLineFill and reset tab page nr  
    let s .= '%#TabLineFill#%T'  
    " right-align the label to close the current tab page  
    if tabpagenr('$') > 1  
        let s .= '%=%#TabLineFill#999Xclose'  
    endif  
    return s  
endfunction  
