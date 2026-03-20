local M = {}

function M.get_project_root()
  local file = vim.fn.expand('%:p')
  local start_path = (file ~= '') and vim.fn.fnamemodify(file, ':p:h') or vim.fn.getcwd()
  local root = vim.fs.find({ '.git', 'ols.json' }, { upward = true, path = start_path })[1]
  return root and vim.fs.dirname(root) or start_path
end

return M
