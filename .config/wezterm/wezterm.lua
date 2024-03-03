local wezterm = require("wezterm")
local c = wezterm.config_builder()

c.font = wezterm.font("JetBrains Mono Fallback")
c.font_size = 10
-- c.line_height = 0.90
c.line_height = 0.9

c.hide_tab_bar_if_only_one_tab = true
c.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

c.window_background_opacity = 0.90
c.enable_scroll_bar = true

c.colors = {
  foreground = "silver",
  background = "#000000",

  cursor_bg = "#00FF33",
  cursor_fg = "black",
  cursor_border = "#52ad70",

  selection_fg = "black",
  selection_bg = "#fffacd",
  scrollbar_thumb = "#505050",
  split = "#444444",
}

c.keys = {
  {
    key = "Tab",
    mods = "CTRL",
    action = wezterm.action.SendKey { key = "Tab", mods = 'CTRL' },
  },
  {
    key = "Tab",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SendKey { key = "Tab", mods = 'CTRL|SHIFT' },
  },
  {
    key = "k",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SendKey { key = "k", mods = 'CTRL|SHIFT' },
  },
}


-- Disable the scroll bar when not needed
wezterm.on('update-status', function(win, p)
  local overrides = win:get_config_overrides() or {}
  overrides.enable_scroll_bar = not p:is_alt_screen_active()
  win:set_config_overrides(overrides)
end)

return c
