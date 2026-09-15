require("user.core")

local lazy = require("lazy")

lazy.setup({
  spec = {
    { import = "user.plugins"},
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",
        "gzip", "zip", "zipPlugin", "tar", "tarPlugin",
        "getscript", "getscriptPlugin", "vimball", "vimballPlugin",
        "2html_plugin", "logipat", "rrhelper", "spellfile_plugin", "matchit",
      },
    },
  },
})
