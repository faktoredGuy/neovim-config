return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        local set_hl = vim.api.nvim_set_hl
        set_hl(0, "SnacksIndent1", { fg = "#1a1a1a" })
        set_hl(0, "SnacksIndent2", { fg = "#313C20" })
        set_hl(0, "SnacksIndent3", { fg = "#495E26" })
        set_hl(0, "SnacksIndent4", { fg = "#60802C" })
        set_hl(0, "SnacksIndent5", { fg = "#77A232" })
      end,
    })
  end,
  opts = {
    dashboard = {
      enabled = true,
      preset = {
        header = [[ If you can stay calm in place where others can't, 
        you can reach that others can't ]],

        keys = {
          { icon = "󰈞 ", key = "f", desc = "find file", action = ":lua Snacks.picker.files()" },
          { icon = "󰄉 ", key = "r", desc = "recent files", action = ":lua Snacks.picker.recent()" },
          { icon = "󰝒 ", key = "n", desc = "new file", action = ":enew" },
          { icon = " ", key = "c", desc = "config", action = ":e " .. vim.fn.stdpath("config") .. "/init.lua" },
          { icon = "󰈆 ", key = "q", desc = "quit neovim", action = ":qa" },
        },
      },
      sections = {
        { section = "header", padding = 2 },
        { section = "keys", gap = 1, padding = 1 },
        {

          text = {
            string.format(
              "neovim v%s.%s.%s | lazy.nvim",
              vim.version().major,
              vim.version().minor,
              vim.version().patch
            ),
          },
          hl = "comment",
          align = "center",
        },
      },
    },

    explorer = {
      enabled = true,
      replace_netrw = true
    },

    indent = {
      enabled = true,
      indent = {
        char = "│",
        hl = {
          "SnacksIndent1",
          "SnacksIndent2",
          "SnacksIndent3",
          "SnacksIndent4",
          "SnacksIndent5",
        }
    }
    },

    terminal = {
      enabled = true,
      win = {
        position = "float",
        border = "rounded",
        width = 0.5,
        height = 0.5,
      },
    },

    notifier = {
      enabled = true,
      timeout = 3000,
    },
  },
  keys = {
    { "<leader>e", function () Snacks.explorer() end, desc = "file explorer"},

    { "<c-\\>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "toggle terminal" },

    { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "notification history" },
    { "<leader>nd", function() Snacks.notifier.hide() end, desc = "dismiss notifications" },
  },
}
