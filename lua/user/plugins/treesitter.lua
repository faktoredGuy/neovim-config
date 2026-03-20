require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "lua", "vim", "vimdoc",
    "json", "jsonc",
    "bash", "yaml", "markdown", "odin"
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
  incremental_selection = { enable = false },
  textobjects = { enable = false },
}
