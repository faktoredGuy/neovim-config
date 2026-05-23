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

-- Alpha dashboard on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function ()
    if vim.fn.argc() == 0 then
      vim.schedule(function ()
        require("alpha").start(true)
      end)
    end
  end
})
