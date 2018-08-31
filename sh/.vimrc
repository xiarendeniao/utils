"使用配色方案  
colorscheme desert 

"制表符为4  
set tabstop=4

"使用空格代替tab
set expandtab
  
"统一缩进为4  
set softtabstop=4  
set shiftwidth=4 

"高亮显示匹配的括号  
set showmatch  
  
"在搜索的时候忽略大小写  
set ignorecase  
   
"高亮被搜索的句子  
set hlsearch  
   
"在搜索时，输入的词句的逐字符高亮（类似firefox的搜索）  
set incsearch  
  
"继承前一行的缩进方式，特别适用于多行注释  
set autoindent  
  
"为C程序提供自动缩进  
set smartindent  

"在被分割的窗口间显示空白，便于阅读  
set fillchars=vert:\ ,stl:\ ,stlnc:\

"状态栏显示当前执行的命令  
set showcmd  

"调用shell的gr命令
:map gr :!gr <cword> <CR>

"调用shell的gr命令，需要回车才执行，会车前可以自行补充目录信息
:map gR :!gr <cword>

"调用shell的gr命令，直接在最常用的工作目录battlesvrd用全词查找
:map g1 :!gr <cword> server/battlesvrd -w \| tee /tmp/gr.h <CR>

".h .cpp之间跳转 不好使，%好像只在:!xxx中有效
":map g2 :ts %:t:r.h <CR>
":map g3 :ts %:t:r.cpp <CR>
"阉割版，.h .cpp在同一个目录下可用
:map gh :w <CR> :e %:r.h <CR> `" zz
:map gH :w <CR> :e %:r.cpp <CR> `" zz

"快捷键调整tag文件：简洁c跳转、带声明的c跳转(--c-types=+px)、lua跳转
:map gc1 :set tags=tags <CR>
:map gc2 :set tags=c_full_tags <CR>
:map gl :set tags=luatags <CR>
"用tt切换到上一次的tab页面
auto tableave * let g:pre_tabpagenr=tabpagenr()
nnoremap <silent> tt :exe "tabn ".g:pre_tabpagenr<CR> 

" 用K在光标出换行
:nnoremap K i<CR><Esc>

"只有一个匹配项直接跳转，有多个则列出所有匹配项选择跳转
map <c-]> g<c-]>

"编码转换
:map mc :!myconv % 1 <CR>
:map mb :!myconv % 2 <CR>

"缩进控制
:map fi :set fdm=indent <CR> :e <CR>
:map fm :set fdm=manual <CR> :e <CR>

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

function CloseDuplicateTabs() 
	let cnt = 0
	let i = 1

	let tpbufflst = []
	let dups = []
	let tabpgbufflst = tabpagebuflist(i)
	while type(tabpagebuflist(i)) == 3
		if index(tpbufflst, tabpagebuflist(i)) >= 0
			call add(dups,i)
		else
			call add(tpbufflst, tabpagebuflist(i))
		endif

		let i += 1
		let cnt += 1
	endwhile

	call reverse(dups)

	for tb in dups
		exec "tabclose ".tb
	endfor

endfunction

command CloseDupTabs :call CloseDuplicateTabs()
