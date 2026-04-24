return {
  'romgrk/barbar.nvim',
  event = "VeryLazy",
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    animation = false,
    auto_hide = false,
    tabpages = true,
    clickable = true,
    automatic_colors = true,
    icons = {
      button = 'x',
      pinned = { button = '📌', filename = true },
      inactive = { separator = { left = '', right = '' } },
      current = { button = 'x' },
      modified = { button = '●' },
      separator = { left = '▎', right = '' },
    },
  },
}
