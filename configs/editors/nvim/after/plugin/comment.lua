-- https://GitHub.com/AlphaKeks/.dotfiles

local comment_installed, comment = pcall(require, "Comment")

if not comment_installed then
  return
end

comment.setup {
  toggler = {
    line = "<Leader>cc",
    block = "<Leader>cb",
  },

  opleader = {
    line = "<Leader>c",
  },

  mappings = {
    basic = true,
    extra = false,
  },
}

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
