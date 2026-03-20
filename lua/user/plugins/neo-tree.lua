require("neo-tree").setup({
  close_if_last_window = true,
  filesystem = {
    bind_to_cwd = true,
    follow_current_file = {
      enabled = true,
      leave_dirs_open = true,
    },
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
    }
  }
})
