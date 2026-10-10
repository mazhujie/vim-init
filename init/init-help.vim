" 汉化插件的按键帮助；插件更新后无需重新修改插件文件。
scriptencoding utf-8
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')

let s:tree_help = {
            \ 'quickhelp': '快捷键帮助',
            \ 'File node mappings': '文件操作',
            \ 'Directory node mappings': '目录操作',
            \ 'Bookmark table mappings': '书签操作',
            \ 'Tree navigation mappings': '文件树导航',
            \ 'Filesystem mappings': '文件系统操作',
            \ 'Tree filtering mappings': '文件过滤',
            \ 'Custom mappings': '自定义按键',
            \ 'Other mappings': '其他操作',
            \ 'Bookmark commands': '书签命令',
            \ 'open in prev window': '在上一个窗口中打开',
            \ 'open in current window': '在当前窗口中打开',
            \ 'open in new tab silently': '在新标签页中打开（不切换）',
            \ 'open in new tab': '在新标签页中打开',
            \ 'preview vsplit': '在左右分屏中预览',
            \ 'preview split': '在上下分屏中预览',
            \ 'open vsplit': '在左右分屏中打开',
            \ 'open split': '在上下分屏中打开',
            \ 'custom open': '选择打开方式',
            \ 'open & close node': '展开／折叠目录',
            \ 'recursively open node': '递归展开目录',
            \ 'close parent of node': '折叠上级目录',
            \ 'close all child nodes of': '折叠所有子目录：',
            \ 'current node recursively': '递归折叠当前目录',
            \ 'explore selected dir': '浏览选中的目录',
            \ 'jump to bookmark table': '跳到书签列表',
            \ 'open bookmark': '打开书签',
            \ 'find dir in tree': '在文件树中定位目录',
            \ 'delete bookmark': '删除书签',
            \ 'go to first child': '跳到第一个子节点',
            \ 'go to last child': '跳到最后一个子节点',
            \ 'go to next sibling': '跳到下一个同级节点',
            \ 'go to prev sibling': '跳到上一个同级节点',
            \ 'go to root': '跳到根目录',
            \ 'go to parent': '跳到上级目录',
            \ 'change tree root to the': '将文件树根目录设为：',
            \ 'selected dir': '选中的目录',
            \ 'move tree root up a dir': '将文件树根目录上移一级',
            \ 'but leave old root open': '并保留原根目录展开',
            \ 'refresh cursor dir': '刷新光标下的目录',
            \ 'refresh current root': '刷新整个文件树',
            \ 'Show menu': '显示操作菜单',
            \ 'change the CWD to the': '将工作目录设为：',
            \ 'change tree root to CWD': '将文件树根目录设为工作目录',
            \ 'hidden files': '隐藏文件',
            \ 'file filters': '文件过滤',
            \ 'files lines': '文件行数',
            \ 'files': '文件',
            \ 'bookmarks': '书签',
            \ 'Close the NERDTree window': '关闭文件树窗口',
            \ 'Zoom (maximize-minimize)': '最大化／还原',
            \ 'the NERDTree window': '文件树窗口',
            \ 'toggle help': '显示／隐藏帮助',
            \ 'preview file': '预览文件',
            \ 'preview': '预览',
            \ 'middle-click': '鼠标中键',
            \ 'double-click': '鼠标双击',
            \ 'single-click': '鼠标单击',
            \ 'Press ': '按 ',
            \ ' for help': ' 查看帮助',
            \ '(on)': '（开启）',
            \ '(off)': '（关闭）',
            \ }

function! s:LongerFirst(left, right) abort
    return strlen(a:right) - strlen(a:left)
endfunction
let s:tree_words = sort(keys(s:tree_help), function('s:LongerFirst'))

function! s:ChineseTreeHelp() dict abort
    call call(s:original_tree_help, [], self)
    for l:number in range(1, line('$'))
        let l:text = getline(l:number)
        if l:text !~# '^"' && l:text !~# '^\s*$'
            break
        endif
        for l:word in s:tree_words
            let l:text = substitute(l:text, '\V' . escape(l:word, '\'), s:tree_help[l:word], 'g')
        endfor
        call setline(l:number, l:text)
    endfor
endfunction

function! s:InstallChineseHelp() abort
    if exists('g:leaderf_loaded') && has('python3') && !get(g:, 'vim_leaderf_help_zh_loaded', 0)
        runtime autoload/leaderf.vim
        execute 'py3file ' . fnameescape(s:home . '/leaderf-help-zh.py')
        let g:vim_leaderf_help_zh_loaded = 1
    endif
    if exists('g:NERDTreeUI') && !exists('s:original_tree_help')
        let s:original_tree_help = g:NERDTreeUI._dumpHelp
        let g:NERDTreeUI._dumpHelp = function('s:ChineseTreeHelp')
    endif
endfunction

augroup VimChineseKeyHelp
    autocmd!
    autocmd VimEnter * call s:InstallChineseHelp()
    autocmd User nerdtree call s:InstallChineseHelp()
augroup END
if v:vim_did_enter
    call s:InstallChineseHelp()
endif
