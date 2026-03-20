require('barbar').setup({
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
})
