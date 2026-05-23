return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      " █████╗ ██████╗ ██╗  ██╗███████╗██╗██╗   ██╗███████╗",
      "██╔══██╗██╔══██╗██║ ██╔╝██ ╔═══╝██║███╗  ██║██ ╔═══╝",
      "███████║██████╔╝█████╔╝ ██████═╗██║█████╗██║██████═╗",
      "██╔══██║██╔══██╗██╔═██╗ ██ ╔═══╝██║██╔═████║██ ╔═══╝",
      "██║  ██║██║  ██║██║  ██╗███████╗██║██║  ╚██║███████╗",
      "╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝╚═╝   ╚═╝ ╚═════╝",
    }

    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Find file", "<cmd>FFFFind<cr>"),
      dashboard.button("r", "󰄉  Recent files", "<cmd>Telescope oldfiles<cr>"),
      dashboard.button("n", "󰝒  New file", "<cmd>enew<cr>"),
      dashboard.button("c", "  Config", "<cmd>e " .. vim.fn.stdpath("config") .. "/init.lua<cr>"),
      dashboard.button("q", "󰈆  Quit neovim", "<cmd>qa<cr>"),
    }

    dashboard.section.footer.val = {
      string.format(
        "neovim v%s.%s.%s | lazy.nvim",
        vim.version().major,
        vim.version().minor,
        vim.version().patch
      ),
    }

    alpha.setup({
      layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 2 },
        dashboard.section.footer,
      },
      opts = {
        margin = 5,
        cursor = true
      },
    })
  end,
}
