return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  config = function()
    require('telescope').setup({
      pickers = {
        oldfiles = {
          cwd_only = true,
          include_current_session = true,
        }
      }
    })
  end,
}
