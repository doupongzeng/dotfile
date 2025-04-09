local wezterm = require 'wezterm'
local act = wezterm.action

return {
  -- 窗口设置
  window_padding = {
    left = 5,
    right = 5,
    top = 2,
    bottom = 2,
  },
  window_decorations = "RESIZE", -- 带有标题栏和边框
  window_background_opacity = 1.0, -- 完全不透明
  initial_cols = 120, -- 默认列数
  initial_rows = 30, -- 默认行数
  window_close_confirmation = 'AlwaysPrompt', -- 关闭窗口时提示

  -- 字体设置
  font = wezterm.font('Maple Mono Normal NL NF CN', { weight = 'Regular', style = 'Normal' }),
  font_size = 13.0,

  -- 颜色方案
  colors = {
    foreground = '#f8f8f2', -- 前景色
    background = '#282a36', -- 背景色
    cursor_bg = '#f8f8f2', -- 光标背景色
    cursor_fg = '#282a36', -- 光标前景色
    cursor_border = '#f8f8f2', -- 光标边框色

    ansi = {
      '#21222c', -- black
      '#ff5555', -- red
      '#50fa7b', -- green
      '#f1fa8c', -- yellow
      '#bd93f9', -- blue
      '#ff79c6', -- magenta
      '#8be9fd', -- cyan
      '#f8f8f2', -- white
    },

    brights = {
      '#6272a4', -- bright black
      '#ff6e6e', -- bright red
      '#69ff94', -- bright green
      '#ffffa5', -- bright yellow
      '#d6acff', -- bright blue
      '#ff92df', -- bright magenta
      '#a4ffff', -- bright cyan
      '#ffffff', -- bright white
    },

    -- 搜索高亮
    selection_fg = '#44475a', -- 选择文本的前景色
    selection_bg = '#50fa7b', -- 选择文本的背景色
  },

  -- 选择和剪贴板设置
  selection_word_boundary = " \t\n{}[]()\"'`,;:", -- 单词边界
  
  -- 移除了无效的 selection_mode 和 automatically_copy_selection 配置
  
  -- 使用 mouse_bindings 来配置选择行为
  mouse_bindings = {
    -- 右键粘贴
    {
      event = { Up = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = wezterm.action.PasteFrom('Clipboard'),
    },
    -- 选择文本时自动复制到剪贴板
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor('ClipboardAndPrimarySelection'),
    },
  },

  -- 终端设置
  term = 'xterm-256color', -- 默认终端类型

  -- 键盘绑定
  keys = {
    {
      key = 'Space',
      mods = 'CTRL',
      action = act.ActivateCopyMode, -- 进入复制模式（类似 Vi 模式）
    },
    {
      key = 'F11',
      action = act.ToggleFullScreen, -- 全屏切换
    },
    -- 添加复制粘贴相关键位
    {
      key = 'v',
      mods = 'CTRL',
      action = act.PasteFrom('Clipboard'), -- 从剪贴板粘贴
    },
  },

  -- 其他设置
  automatically_reload_config = true, -- 自动重载配置文件
  check_for_updates = false, -- 禁用更新检查
}
