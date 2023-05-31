-- https://GitHub.com/AlphaKeks/.dotfiles

require("alphakeks.globals")

autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 69 })
  end,
})

autocmd("TermOpen", {
  command = "setl nonu rnu so=0",
})

require("alphakeks.plugins")

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
