require('telescope').setup({
  defaults = {},
  pickers = {
    oldfiles = {
      cwd_only = true,
      include_current_session = true,
    }
  }
})
