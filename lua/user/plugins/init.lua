return {
  spec = {
    {
      "EdenEast/nightfox.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        vim.cmd("colorscheme carbonfox")
      end,
    },
  },
  { import = "user.plugins.alpha" },
  { import = "user.plugins.barbar" },
  { import = "user.plugins.cmp" },
  { import = "user.plugins.dap" },
  { import = "user.plugins.fff" },
  { import = "user.plugins.indent-blankline" },
  { import = "user.plugins.lsp" },
  { import = "user.plugins.lsp_signature" },
  { import = "user.plugins.lualine" },
  { import = "user.plugins.mason" },
  { import = "user.plugins.neo-tree" },
  { import = "user.plugins.telescope" },
  { import = "user.plugins.treesitter" },
  { import = "user.plugins.triforce" },
  { import = "user.plugins.vim-css-color" },
  { import = "user.plugins.nvim-autopairs" },
}
