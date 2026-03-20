return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    require("fff.download").download_or_build_binary()
  end,

  lazy = false,
  keys = {
    { "<leader>f", function() require('fff').find_files() end, desc = 'Find files (FFF)' },
    { "<leader>F", function() require('fff').find_in_git_root() end, desc = 'Find in git root (FFF)' },
    { "<leader>g", function() require('fff').live_grep() end, desc = 'Live grep (FFF)' },
  },
  cmd = {
    "FFFFind",
    "FFFScan",
    "FFFHealth",
    "FFFOpenLog",
  },
  opts = {

    prompt = '󰈞 ',
    title = 'FFF Finder',
    max_results = 100,
    max_threads = 4,
    lazy_sync = true,

    layout = {
      height = 0.8,
      width = 0.8,
      prompt_position = 'bottom',
      preview_position = 'right',
      preview_size = 0.5,
      show_scrollbar = true,
      path_shorten_strategy = 'middle_number',
    },


    preview = {
      enabled = true,
      max_size = 10 * 1024 * 1024, -- 10MB
      chunk_size = 8192,
      binary_file_threshold = 1024,
      line_numbers = false,
      wrap_lines = false,
      show_file_info = true,
      filetypes = {
        markdown = { wrap_lines = true },
        text = { wrap_lines = true },
      },
    },


    keymaps = {
      close = '<Esc>',
      select = '<CR>',
      select_split = '<C-s>',
      select_vsplit = '<C-v>',
      select_tab = '<C-t>',
      move_up = { '<Up>', '<C-p>' },
      move_down = { '<Down>', '<C-n>' },
      preview_scroll_up = '<C-u>',
      preview_scroll_down = '<C-d>',
      toggle_debug = '<F2>',
    },

    frecency = {
      enabled = true,
      db_path = vim.fn.stdpath('cache') .. '/fff_nvim',
    },

    history = {
      enabled = true,
      db_path = vim.fn.stdpath('data') .. '/fff_queries',
      min_combo_count = 3,
      combo_boost_score_multiplier = 100,
    },

    debug = {
      enabled = false,
      show_scores = false,
    },

    logging = {
      enabled = true,
      log_file = vim.fn.stdpath('log') .. '/fff.log',
      log_level = 'info',
    },
  },
}
