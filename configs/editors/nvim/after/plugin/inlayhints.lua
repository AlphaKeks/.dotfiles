-- https://GitHub.com/AlphaKeks/.dotfiles

local inlay_hints_installed, inlay_hints = pcall(require, "lsp-inlayhints")
if inlay_hints_installed then
  inlay_hints.setup({
    inlay_hints = {
      type_hints = {
        show = true,
        prefix = "",
        remove_colon_start = true,
      },

      parameter_hints = {
        show = false,
      },

      highlight = "Comment",
    },
  })
end

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
