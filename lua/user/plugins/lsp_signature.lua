return {
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    config = function()
      require("lsp_signature").setup({
        bind = true,
        handler_opts = {
          border = "rounded"
        },
        hint_enable = true,
        hint_prefix = "->",
        hint_scheme = "String",
        hi_parameter = "LspSignatureActiveParameter",
        always_trigger = false,
        max_height = 12,
        max_width = 80,
        floating_window = true,
        floating_window_above_curl_line = true,
        toggle_key = '<C-s>',
        debounce = 200,
      })
    end,
  },
}
