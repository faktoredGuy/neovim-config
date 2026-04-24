return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufReadPost", "BufNewFile" }, -- Загружаем только когда открыли файл с кодом
  config = function()
    local status_ok, todo_comments = pcall(require, "todo-comments")
    if not status_ok then
      return
    end

    todo_comments.setup({
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "hack" }, -- Ваш кастомный ключ
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", color = "default" },
        NOTE = { icon = " ", color = "hint" },
        TEST = { icon = "⏲ ", color = "test" },
      },
      highlight = {
        multiline = true,
        multiline_pattern = "^.",
        multiline_context = 10,
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*:]],
      },
      colors = {
        -- Ваши кастомные цвета для i3 ricing
        error   = { "#FF5555" },
        info    = { "#8BE9FD" },
        hack    = { "#FFB86C" },
        warning = { "#F1FA8C" },
        default = { "#BD93F9" },
        hint    = { "#50FA7B" },
        test    = { "#FF8C42" },
      },
    })
  end,
}
