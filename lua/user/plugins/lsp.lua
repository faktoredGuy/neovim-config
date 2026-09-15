return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local function get_root(markers)
        return function(fname)
          return vim.fs.root(fname, markers)
        end
      end

      -- C++ (clangd)
      vim.lsp.config("clangd", {
        capabilities = capabilities,
        root_dir = get_root({ "compile_commands.json", "compile_flags.txt", ".git" }),
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
