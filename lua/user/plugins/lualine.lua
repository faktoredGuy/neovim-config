return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require('lualine').setup({
        options = {
          theme = 'carbonfox',
          -- theme = 'melange',
          icons_enabled = true,
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
        }
      })
    end,
  },
}
