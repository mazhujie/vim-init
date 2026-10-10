# -*- coding: utf-8 -*-
"""Translate LeaderF key help without modifying the installed plugin."""
from functools import wraps
from importlib import import_module

TRANSLATIONS = {
    'open file under cursor': '打开光标下的文件',
    'open file under cursor in a horizontally split window': '在上下分屏中打开文件',
    'open file under cursor in a vertically split window': '在左右分屏中打开文件',
    'open file under cursor in a new tabpage': '在新标签页中打开文件',
    'switch to input mode': '切换到输入模式',
    'select multiple files': '选择／取消选择当前文件（支持多选）',
    'select all files': '选择所有文件',
    'clear all selections': '取消所有选择',
    'preview the file': '预览文件',
    'preview the result': '预览结果',
    'quit': '退出',
    'refresh the cache': '刷新缓存',
    'toggle this help': '显示／隐藏帮助',
    'wipe out buffer under cursor': '彻底移除光标下的缓冲区',
    'delete buffer under cursor': '关闭光标下的缓冲区',
    'remove from mru list': '从最近文件列表中移除',
    'delete the line under the cursor': '从结果中移除当前行',
    'output result quickfix list': '将结果放入快速修复列表',
    'output result location list': '将结果放入位置列表',
    'replace a pattern': '替换匹配内容',
    'apply the changes to buffer without saving': '应用修改到缓冲区（不保存）',
    'apply the changes to buffer and save': '应用修改并保存',
    'undo the last changes applied': '撤销上次应用的修改',
}


def translate(line):
    keys, separator, description = line.partition(' : ')
    if separator and description in TRANSLATIONS:
        return keys.replace('<double-click>', '<双击>') + separator + TRANSLATIONS[description]
    return line.replace('Press <F1> for help', '按 <F1> 查看帮助')


def translated_help(original):
    @wraps(original)
    def wrapper(self, *args, **kwargs):
        return [translate(line) for line in original(self, *args, **kwargs)]
    wrapper._help_zh = True
    return wrapper


def install():
    managers = {
        'fileExpl': 'FileExplManager',
        'bufExpl': 'BufExplManager',
        'mruExpl': 'MruExplManager',
        'tagExpl': 'TagExplManager',
        'bufTagExpl': 'BufTagExplManager',
        'functionExpl': 'FunctionExplManager',
        'rgExpl': 'RgExplManager',
    }
    for module_name, class_name in managers.items():
        cls = getattr(import_module('leaderf.' + module_name), class_name)
        if not getattr(cls._createHelp, '_help_zh', False):
            cls._createHelp = translated_help(cls._createHelp)

    from leaderf.manager import Manager
    if getattr(Manager._createHelpHint, '_help_zh', False):
        return
    original = Manager._createHelpHint

    @wraps(original)
    def help_hint(self, *args, **kwargs):
        result = original(self, *args, **kwargs)
        if not self._show_help and self._help_length:
            instance = self._getInstance()
            buffer = instance.buffer
            index = len(buffer) - 1 if instance.isReverseOrder() else 0
            old_modifiable = buffer.options['modifiable']
            try:
                buffer.options['modifiable'] = True
                buffer[index] = translate(buffer[index])
            finally:
                buffer.options['modifiable'] = old_modifiable
        return result

    help_hint._help_zh = True
    Manager._createHelpHint = help_hint


install()
