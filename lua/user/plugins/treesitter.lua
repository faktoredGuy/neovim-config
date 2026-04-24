return {
  "nvim-treesitter/nvim-treesitter",
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
        "bash", "yaml", "markdown", "odin", "cpp",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,

        disable = function(lang, buf)
          return vim.api.nvim_buf_line_count(buf) > 1000
        end,
      },
      indent = { enable = true },

      semantic_tokens = { enable = true },
    })
  end,
}
