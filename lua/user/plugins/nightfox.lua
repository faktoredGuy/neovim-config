return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require('nightfox').setup({
      options = {
        transparent = true,
        terminal_colors = true,
      },
      palettes = {
        carbonfox = {

          orange  = "#ff931e",
          red     = "#c4746e",
          magenta = "#e46876",
          blue    = "#7fb4ca",
          yellow  = "#c0a36e",

          green   = "#8a9a7b",
          comment = "#7a8382",

          bg1     = "NONE",
          bg0     = "NONE",
        }
      },
      groups = {
        carbonfox = {

          String   = { fg = "palette.green" },
          Comment  = { fg = "palette.comment", style = "italic" },

          Keyword  = { fg = "palette.orange", style = "bold" },

          Visual   = { bg = "palette.orange", fg = "#000000" },

          NormalFloat = { bg = "palette.bg1" },
          SignColumn  = { bg = "palette.bg1" },
        }
      }
    })

    vim.cmd.colorscheme 'carbonfox'
  end,
}
