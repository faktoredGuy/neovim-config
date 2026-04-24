return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    config = function()
      local highlight = {
        "IblColor1",
        "IblColor2",
        "IblColor3",
        "IblColor4",
        "IblColor5",
      }

      local hooks = require("ibl.hooks")

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        local set_hl = vim.api.nvim_set_hl
        set_hl(0, "IblColor1", { fg = "#1a1a1a" })
        set_hl(0, "IblColor2", { fg = "#3D1F00" })
        set_hl(0, "IblColor3", { fg = "#7A3E00" })
        set_hl(0, "IblColor4", { fg = "#B75E00" })
        set_hl(0, "IblColor5", { fg = "#F47E00" })
      end)

      require("ibl").setup({
        scope = { enabled = false },
        indent = {
          char = "│",
          tab_char = "│",
          priority = 2,
          highlight = highlight,
        },
      })
    end,
  },
}
