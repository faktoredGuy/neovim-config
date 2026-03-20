require('toggleterm').setup({
  open_mapping = [[<c-\>]],
  direction = 'horizontal',
  shell = 'zsh',
  shell_args = { '-l' },
  cwd = function()
    return require("user.utils.project").get_project_root()
  end,
})
