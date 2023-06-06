-- https://GitHub.com/AlphaKeks/.dotfiles

function nn(lhs, rhs, opts)
  vim.keymap.set("n", lhs, rhs, opts or { silent = true })
end

function Print(...)
  vim.print(vim.inspect(...))
  return ...
end

autocmd = vim.api.nvim_create_autocmd
augroup = vim.api.nvim_create_augroup

function usercmd(name, callback, opts)
  vim.api.nvim_create_user_command(name, callback, opts or {})
end

vim.lsp.setup = function(server, opts)
  local lspconfig_installed, lspconfig = pcall(require, "lspconfig")

  if not lspconfig_installed then
    vim.notify "Language server could not be setup."
    vim.notify "nvim-lspconfig is not installed."
    return
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local lsp_cmp_source_installed, lsp_cmp_source = pcall(require, "cmp_nvim_lsp")

  if lsp_cmp_source_installed then
    capabilities = lsp_cmp_source.default_capabilities(capabilities)
  end

  local server_opts = {
    capabilities = capabilities,
  }

  for key, value in pairs(opts or {}) do
    server_opts[key] = value
  end

  lspconfig[server].setup(server_opts)

  return server_opts
end

-- vim: et ts=2 sw=2 sts=2 ai si ft=lua
