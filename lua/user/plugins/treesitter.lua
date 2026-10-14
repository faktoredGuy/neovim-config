return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local status_ok, configs = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
      return
    end

    configs.setup({
      ensure_installed = {
        "lua", "vim", "vimdoc", "json", "jsonc",
        "bash", "yaml", "markdown", "markdown_inline",
        "cpp", "typst", "odin",
      },
      highlight = { enable = true },
      indent = { enable = true },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {

            ["af"] = { query = "@function.outer", desc = "Select outer part of a function" },
            ["if"] = { query = "@function.inner", desc = "Select inner part of a function" },
            ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
          },
          goto_previous_start = {
            ["[f"] = { query = "@function.outer", desc = "Prev function start" },
            ["[c"] = { query = "@class.outer", desc = "Prev class start" },
          },
        },
      },
    })
  end,
}
