return {
  "wnkz/monoglow.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function(_, opts)
    require("monoglow").setup(opts)
    
    vim.cmd.colorscheme("monoglow")
  end,
}
