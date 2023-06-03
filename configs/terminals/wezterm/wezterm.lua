-- https://GitHub.com/AlphaKeks/.dotfiles

local term = require("wezterm")

return {
  default_prog = { "zsh" },
  color_scheme = "Catppuccin Mocha",
  colors = {
    background = "11111b",
  },
  font = term.font_with_fallback {
    "JetBrains Mono Regular",
  },
  font_size = 18,
  line_height = 1,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = false,
  -- window_background_opacity = 0.80,
  window_background_opacity = 1,
  -- default_cursor_style = "BlinkingBlock",
  cursor_blink_rate = 727,
  cursor_blink_ease_in = "Linear",
  cursor_blink_ease_out = "Linear",
  animation_fps = 240,
  scrollback_lines = 1000000,
  audible_bell = "Disabled",
  window_padding = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 0
  },
  keys = {
    {
      key = "f",
      mods = "CTRL|SHIFT",
      action = term.action.SendString("source ~/.local/bin/scripts/gtp.sh\r"),
    },
    {
      key = "^",
      mods = "CTRL",
      action = term.action.SendKey({
        key = "^",
        mods = "CTRL",
      }),
    },
    {
      key = "Backspace",
      mods = "CTRL",
      action = term.action.SendKey({
        key = "w",
        mods = "CTRL",
      }),
    },
  },
}

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
