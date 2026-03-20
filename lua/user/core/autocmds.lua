-- LSP keybindings
vim.api.nvim_create_autocmd('lspattach', {
  callback = function(args)
    local buf = args.buf
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = buf, desc = 'hover' })
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { buffer = buf, desc = 'previous diagnostic' })
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = buf, desc = 'next diagnostic' })
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { buffer = buf, desc = 'quickfix' })
  end,
})

-- Odin
vim.api.nvim_create_autocmd("FileType", {
  pattern = "odin",
  callback = function()
    vim.env.ODIN_ROOT = "/usr/lib/odin"
  end
})

-- Auto-cwd
local last_cwd = nil
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" or vim.fn.filereadable(path) ~= 1 then return end
    local file_dir = vim.fn.fnamemodify(path, ":p:h")
    if last_cwd == file_dir then return end
    last_cwd = file_dir
    pcall(function() vim.cmd("lcd " .. vim.fn.fnameescape(file_dir)) end)
  end,
})

-- Sync terminals on dir change
vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    local dir = vim.fn.getcwd()
    local ok, terminals = pcall(require, "toggleterm.terminal")
    if ok then
      for _, term in ipairs(terminals.get_all()) do
        if term.job_id then
          vim.api.nvim_chan_send(term.job_id, "cd " .. vim.fn.shellescape(dir) .. "\n")
        end
      end
    end
  end,
})

-- Alpha dashboard on startup
vim.api.nvim_create_autocmd("vimenter", {
  callback = function()
    if vim.fn.argc() == 0 and vim.fn.line2byte('$') == -1 and vim.bo.buftype == '' then
      pcall(function()
       require("alpha").start(true)
      end)
    end
  end,
})
