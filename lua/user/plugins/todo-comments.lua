local status_ok, todo_comments = pcall(require, "todo-comments")
if not status_ok then
  return
end

todo_comments.setup({
  keywords = {
    FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "hack" },
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
    error   = { "#FF5555" }, -- FIX:
    info    = { "#8BE9FD" }, -- TODO:
    hack    = { "#FFB86C" }, -- HACK:
    warning = { "#F1FA8C" }, -- WARN:
    default = { "#BD93F9" }, -- PERF:
    hint    = { "#50FA7B" }, -- NOTE:
    test    = { "#FF8C42" }, -- TEST:

    -- hack нет в стандартных colors, поэтому сделаем отдельную группу
},
})
