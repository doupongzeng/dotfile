local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local static_is_window_maximized = false
local static_current_image_index = 0

local home_dir = wezterm.home_dir

wezterm.on("gui-startup", function(cmd)
  -- 获取主屏幕的信息
  -- local screen = wezterm.gui.screens().main
  local screen = wezterm.gui.screens().active
  -- 定义窗口大小（例如屏幕宽高的70%）
  local ratio = 0.7
  local width = screen.width * ratio
  local height = screen.height * ratio

  -- 启动一个新窗口
  local tab, pane, window = mux.spawn_window{
    position = {
      x = (screen.width - width) /2,
      y = (screen.height -height) /2,
      origin = 'ActiveScreen'
    }
  }

  -- 设置窗口大小
  window:gui_window():set_inner_size(width, height)

  -- -- 计算窗口的中心位置
  -- local x = (screen.width - width) / 2
  -- local y = (screen.height - height) / 2
  --
  -- -- 将窗口移动到屏幕中央
  -- window:gui_window():set_position(x, y)
end)

wezterm.on("toggle-image", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local image_paths = {
    home_dir .. "/dotfile/images/04190_clouds_1680x1050.jpg",
    home_dir .. "/dotfile/images/04180_grandtetonsunset_1680x1050.jpg",
    "",
  }

  static_current_image_index = static_current_image_index + 1
  if static_current_image_index > #image_paths then
    static_current_image_index = 1
  end

  overrides.window_background_image = image_paths[static_current_image_index]
  window:set_config_overrides(overrides)
end)

return {
  -- 窗口设置
  window_padding = {
    left = 5,
    right = 5,
    top = 2,
    bottom = 2,
  },
  window_decorations = "NONE",             -- 带有标题栏和边框 ubuntu24
  -- window_decorations = "RESIZE",             -- 带有标题栏和边框 ubuntu22
  window_background_opacity = 1.0,           -- 完全不透明
  initial_cols = 120,                        -- 默认列数
  initial_rows = 30,                         -- 默认行数
  window_close_confirmation = "AlwaysPrompt", -- 关闭窗口时提示

  -- 字体设置
  font = wezterm.font("Maple Mono Normal NL NF CN", { weight = "Regular", style = "Normal" }),
  font_size = 13.0,

  -- window_background_gradient

  -- 颜色方案
  colors = {
    foreground = "#f8f8f2",  -- 前景色
    background = "#282a36",  -- 背景色
    cursor_bg = "#f8f8f2",   -- 光标背景色
    cursor_fg = "#282a36",   -- 光标前景色
    cursor_border = "#f8f8f2", -- 光标边框色

    ansi = {
      "#21222c", -- black
      "#ff5555", -- red
      "#50fa7b", -- green
      "#f1fa8c", -- yellow
      "#bd93f9", -- blue
      "#ff79c6", -- magenta
      "#8be9fd", -- cyan
      "#f8f8f2", -- white
    },

    brights = {
      "#6272a4", -- bright black
      "#ff6e6e", -- bright red
      "#69ff94", -- bright green
      "#ffffa5", -- bright yellow
      "#d6acff", -- bright blue
      "#ff92df", -- bright magenta
      "#a4ffff", -- bright cyan
      "#ffffff", -- bright white
    },

    -- 搜索高亮
    selection_fg = "#44475a", -- 选择文本的前景色
    selection_bg = "#50fa7b", -- 选择文本的背景色
  },

  -- 选择和剪贴板设置
  selection_word_boundary = " \t\n{}[]()\"'`,;:", -- 单词边界

  -- 使用 mouse_bindings 来配置选择行为
  mouse_bindings = {
    -- 右键粘贴
    {
      event = { Up = { streak = 1, button = "Right" } },
      mods = "NONE",
      action = wezterm.action.PasteFrom("Clipboard"),
    },
    -- 选择文本时自动复制到剪贴板
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "NONE",
      action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection"),
    },
  },

  -- 终端设置
  term = "xterm-256color", -- 默认终端类型

  -- 键盘绑定
  keys = {
    {
      key = "b",
      mods = "CTRL",
      action = act.ActivateCopyMode, -- 进入复制模式（类似 Vi 模式）
    },
    {
      key = "F11",
      mods = "CTRL",
      action = act.ToggleFullScreen, -- 全屏切换
    },
    {
      key = "F11",
      mods = "",
      action = wezterm.action_callback(function(window, _pane)
        if static_is_window_maximized then
          window:restore()
          static_is_window_maximized = false
        else
          window:maximize()
          static_is_window_maximized = true
        end
      end),
    },
    -- 添加复制粘贴相关键位
    {
      key = "v",
      mods = "CTRL|SHIFT",
      action = act.PasteFrom("Clipboard"), -- 从剪贴板粘贴
    },
    {
      key = ",",
      mods = "SUPER",
      action = act.EmitEvent("toggle-image"), -- 从剪贴板粘贴
    },
  },

  -- 其他设置
  automatically_reload_config = true, -- 自动重载配置文件
  check_for_updates = false,         -- 禁用更新检查
  -- disable_default_key_bindings = true,
}
