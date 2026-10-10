" 用中文查询当前生效的配置快捷键：:MapHelp [关键词]
scriptencoding utf-8

let s:keys = [
            \ ['<C-p>', '搜索：按文件名查找文件'],
            \ ['<C-n>', '搜索：查找最近打开的文件'],
            \ ['<M-n>', '搜索：查找已打开的缓冲区'],
            \ ['<M-p>', '搜索：查看当前文件的函数列表'],
            \ ['<M-P>', '搜索：查看当前文件的标签列表'],
            \ ['<M-m>', '搜索：查找项目标签'],
            \ ['<M-e>', '窗口：选择要切换的窗口'],
            \ ['<Space>nn', '文件树：打开文件树'],
            \ ['<Space>no', '文件树：切换到文件树窗口'],
            \ ['<Space>nm', '文件树：在当前标签页镜像文件树'],
            \ ['<Space>nt', '文件树：显示／隐藏文件树'],
            \ ['<Space>ha', '诊断：清除错误标记'],
            \ ['<Space>rg', '语法：检查英语语法'],
            \ ['<Space>rr', '语法：打开错误说明'],
            \ ['<Space>rv', '语法：切换到错误说明窗口'],
            \ ['<Space>rs', '语法：重置检查结果'],
            \ ['<Space>rx', '语法：关闭错误说明窗口'],
            \ ['<Space>rm', '语法：移除当前错误'],
            \ ['<Space>rd', '语法：禁用当前规则'],
            \ ['<Space>rn', '语法：下一个错误'],
            \ ['<Space>rp', '语法：上一个错误'],
            \ ['<Leader>bn', '缓冲区：切换到下一个文件'],
            \ ['<Leader>bp', '缓冲区：切换到上一个文件'],
            \ ['<Leader>tc', '标签页：新建'],
            \ ['<Leader>tq', '标签页：关闭当前标签页'],
            \ ['<Leader>tn', '标签页：下一个'],
            \ ['<Leader>tp', '标签页：上一个'],
            \ ['<Leader>to', '标签页：只保留当前标签页'],
            \ ['<Leader>tl', '标签页：将当前标签页左移'],
            \ ['<Leader>tr', '标签页：将当前标签页右移'],
            \ ['<M-Left>', '标签页：将当前标签页左移'],
            \ ['<M-Right>', '标签页：将当前标签页右移'],
            \ ['<C-h>', '移动：光标左移'],
            \ ['<C-j>', '移动：光标下移'],
            \ ['<C-k>', '移动：光标上移'],
            \ ['<C-l>', '移动：光标右移'],
            \ ['<C-a>', '移动：光标移到行首', ['i', 'c']],
            \ ['<C-e>', '移动：光标移到行尾', ['i', 'c']],
            \ ['<C-d>', '编辑：删除光标下的字符', ['i', 'c']],
            \ ['<C-b>', '移动：光标左移', ['c']],
            \ ['<C-f>', '补全：显示命令补全候选', ['c']],
            \ ['<M-h>', '移动：跳到上一个单词'],
            \ ['<M-l>', '移动：跳到下一个单词'],
            \ ['<M-j>', '移动：向下移动一屏幕行'],
            \ ['<M-k>', '移动：向上移动一屏幕行'],
            \ ['<M-y>', '编辑：删除到行尾'],
            \ ['<M-H>', '窗口：切换到左侧窗口'],
            \ ['<M-J>', '窗口：切换到下方窗口'],
            \ ['<M-K>', '窗口：切换到上方窗口'],
            \ ['<M-L>', '窗口：切换到右侧窗口'],
            \ ['<M-q>', '终端：退出终端输入模式'],
            \ ['<M-=>', '选择：扩大选中范围'],
            \ ['<M-->', '选择：缩小选中范围'],
            \ ['<F2>', '搜索：在项目中查找光标下的单词'],
            \ ['<F4>', '构建：运行 cmake'],
            \ ['<F5>', '运行：执行当前文件'],
            \ ['<F6>', '构建：运行项目测试'],
            \ ['<F7>', '构建：使用 make 编译项目'],
            \ ['<F8>', '运行：运行项目'],
            \ ['<F9>', '构建：使用 gcc 编译当前文件'],
            \ ['<F10>', '诊断：显示／隐藏快速修复列表'],
            \ ]
for s:number in range(0, 9)
    let s:tab = s:number == 0 ? 10 : s:number
    call add(s:keys, ['<Leader>' . s:number, '标签页：切换到第 ' . s:tab . ' 个标签页'])
    call add(s:keys, ['<M-' . s:number . '>', '标签页：切换到第 ' . s:tab . ' 个标签页'])
endfor

function! s:MapHelp(keyword) abort
    let l:leader = get(g:, 'mapleader', "\\")
    let l:mode_names = {'n': '普通', 'x': '选择', 'o': '操作', 'i': '插入', 'c': '命令', 't': '终端'}
    let l:lines = ['Vim 常用快捷键（当前生效的配置）',
                \ 'q / Esc 关闭；/ 搜索；:MapHelp 关键词 按中文说明筛选',
                \ 'Leader 键：' . (l:leader == ' ' ? '空格' : l:leader), '']
    for l:item in s:keys
        let l:modes = []
        for l:mode in get(l:item, 2, ['n', 'x', 'o', 'i', 'c', 't'])
            if !empty(maparg(l:item[0], l:mode))
                call add(l:modes, l:mode_names[l:mode])
            endif
        endfor
        let l:key = substitute(l:item[0], '<Leader>', l:leader == ' ' ? '<Space>' : escape(l:leader, '\&'), 'g')
        if !empty(l:modes) && (empty(a:keyword) || stridx(l:key . ' ' . l:item[1], a:keyword) >= 0)
            call add(l:lines, printf('%-18s %s  [%s]', l:key, l:item[1], join(l:modes, '／')))
        endif
    endfor
    if len(l:lines) == 4
        call add(l:lines, '没有匹配的快捷键。')
    endif
    noautocmd botright new
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
    setlocal nonumber norelativenumber nowrap
    call setline(1, l:lines)
    setlocal nomodifiable
    nnoremap <silent><buffer> q :close<CR>
    nnoremap <silent><buffer> <Esc> :close<CR>
    normal! gg
endfunction

command! -nargs=? MapHelp call s:MapHelp(<q-args>)
