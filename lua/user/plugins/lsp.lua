local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- OLS
local ols_path = vim.fn.stdpath("data") .. "/mason/bin/ols"
vim.lsp.config.ols = {
  cmd = { ols_path },
  capabilities = capabilities,
  root_dir = vim.fs.root(0, { "ols.json", ".git" }),
}
vim.lsp.enable("ols")
