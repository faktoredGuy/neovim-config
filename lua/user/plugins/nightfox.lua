return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require('nightfox').setup({
      options = {
        transparent = true,
      },
      palettes = {
        carbonfox = {
          green = "#e2a478",
        }
      },
      groups = {
        all = {

          Visual = { bg = "#ff9e64", fg = "#000000" },
        }
      }
    })
    vim.cmd.colorscheme 'carbonfox'
  end,
}
