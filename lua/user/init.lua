require("user.core")
require("user.utils.project")

require("lazy").setup({
  spec = {
    { import = "user.plugins"},
  },
})
