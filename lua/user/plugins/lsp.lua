return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local function get_root(markers)
        return vim.fs.root(0, markers)
      end

      -- OLS
      local ols_path = vim.fn.stdpath("data") .. "/mason/bin/ols"
      vim.lsp.config("ols", {
        cmd = { ols_path },
        capabilities = capabilities,
        root_dir = get_root({"ols.json", ".git"}),
      })
      vim.lsp.enable("ols")

      -- C++
      vim.lsp.config("clangd", {
        capabilities = capabilities,
        root_dir = get_root({"compile_commands.json", "compile_flags.txt", ".git"}),
      })
      vim.lsp.enable("clangd")

      -- lua_ls
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })
      vim.lsp.enable("lua_ls")
    end,
  },
}
