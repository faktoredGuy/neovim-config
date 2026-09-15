return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      separator_style = "thin",
      show_buffer_close_icons = false,
      show_close_icon = false,
    },
  },
  keys = {
    { "<C-,", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
    { "<C-.>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "<C-q>", "<cmd>bdelete<cr>", desc = "Close buffer" },
    { "<C-1>", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Buffer 1" },
    { "<C-2>", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Buffer 2" },
    { "<C-3>", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Buffer 3" },
    { "<C-4>", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Buffer 4" },
    { "<C-5>", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Buffer 5" },
    { "<C-6>", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "Buffer 6" },
    { "<C-7>", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "Buffer 7" },
    { "<C-8>", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "Buffer 8" },
    { "<C-9>", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "Buffer 9" },
    { "<C-0>", "<cmd>BufferLineGoToBuffer -1<cr>", desc = "Last buffer" },
  },
}
