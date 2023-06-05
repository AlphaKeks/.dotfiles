-- https://GitHub.com/AlphaKeks/.dotfiles

local telescope_installed, telescope = pcall(require, "telescope")

if not telescope_installed then
  return
end

local pickers = require("telescope.builtin")
local themes = require("telescope.themes")
local actions = require("telescope.actions")
local fb_actions = telescope.extensions.file_browser.actions
local filebrowser = telescope.extensions.file_browser.file_browser

telescope.setup({
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
    ["file_browser"] = {
      hijack_netrw = true,
      hidden = true,
      previewer = true,
      initial_mode = "normal",
      sorting_strategy = "ascending",
      mappings = {
        ["n"] = {
          ["a"] = fb_actions.create,
          ["d"] = fb_actions.remove,
          ["r"] = fb_actions.rename
        },
        ["i"] = {
          ["<C-a>"] = fb_actions.create,
          ["<C-d>"] = fb_actions.remove,
          ["<C-r>"] = fb_actions.rename,
          ["<ESC>"] = actions.close,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous
        }
      },
    },

    ["ui-select"] = {
      themes.get_cursor(),
    },
  },
})

telescope.load_extension("file_browser")
telescope.load_extension("ui-select")

local ivy = function(opts)
  local ret = themes.get_ivy({
    layout_config = {
      height = 0.4,
    },
  })

  for key, value in pairs(opts or {}) do
    ret[key] = value
  end

  return ret
end

nn("<C-f>", function()
  pickers.current_buffer_fuzzy_find(ivy())
end)

nn("<Leader>ff", function()
  local opts = ivy({
    hidden = true,
    follow = true,
    show_untracked = true,
    file_ignore_patterns = { "zsh/plugins/*" },
  })

  if not pcall(pickers.git_files, opts) then
    pickers.find_files(opts)
  end
end)

nn("<Leader>fb", function()
  pcall(pickers.buffers, ivy({
    initial_mode = "normal",
  }))
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

nn("<Leader>e", function()
  filebrowser(ivy({
    hidden = true,
    cwd = vim.fn.expand("%:p:h"),
    initial_mode = "normal",
  }))
end)

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
