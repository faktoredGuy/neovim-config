return {
  'gisketch/triforce.nvim',
  dependencies = { 'nvzone/volt' },
  cmd = { "Triforce" },

  opts = {
    custom_languages = {
      odin = { icon = '🔷', name = 'Odin' },
    },
    notifications = {
      enabled = true,
      level_up = true,
      achievements = true,
    },
    keymap = {
      show_profile = '<leader>tt',
    },
  },
}
