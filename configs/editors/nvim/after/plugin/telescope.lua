-- https://GitHub.com/AlphaKeks/.dotfiles

local telescope_installed, telescope = pcall(require, "telescope")

if not telescope_installed then
  return
end

local pickers = require "telescope.builtin"
local themes = require "telescope.themes"
local actions = require "telescope.actions"

telescope.setup {
  defaults = {
    path_display = { "shorten" },
    prompt_prefix = "  ",

    mappings = {
      ["i"] = {
        ["<ESC>"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },

  extensions = {
    ["ui-select"] = {
      themes.get_cursor(),
    },
  },
}

telescope.load_extension "ui-select"

local function ivy(opts)
  local ret = themes.get_ivy {
    layout_config = {
      height = 0.4,
    },
  }

  for key, value in pairs(opts or {}) do
    ret[key] = value
  end

  return ret
end

nn("<C-f>", function()
  pickers.current_buffer_fuzzy_find(ivy())
end)

nn("<Leader>ff", function()
  local opts = ivy {
    hidden = true,
    follow = true,
    show_untracked = true,
    file_ignore_patterns = { "zsh/plugins/*", "%.lock", "%-lock.json", "%.wasm", ".direnv/*" },
  }

  if not pcall(pickers.git_files, opts) then
    pickers.find_files(opts)
  end
end)

nn("<Leader>fb", function()
  pcall(pickers.buffers, ivy {
    initial_mode = "normal",
  })
end)

nn("<Leader>fh", function()
  pickers.help_tags(ivy())
end)

nn("<Leader>fl", function()
  pickers.live_grep(ivy())
end)

nn("<Leader>fd", function()
  pickers.diagnostics(ivy())
end)

nn("<Leader>fr", function()
  pickers.lsp_references(ivy())
end)

nn("<Leader>gd", function()
  pickers.lsp_definitions(ivy())
end)

nn("<Leader>fs", function()
  pickers.lsp_workspace_symbols(ivy())
end)

nn("<Leader>fi", function()
  pickers.lsp_implementations(ivy())
end)

nn("<Leader>fg", function()
  pcall(pickers.git_commits, {
    initial_mode = "normal",
    layout_config = {
      height = 0.9,
      width = 0.9,
    },
  })
end)

nn("<Leader>gs", function()
  pcall(pickers.git_status, {
    initial_mode = "normal",
    layout_config = {
      height = 0.9,
      width = 0.9,
    },
  })
end)

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
