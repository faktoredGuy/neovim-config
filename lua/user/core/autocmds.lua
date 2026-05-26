-- LSP keybindings
vim.api.nvim_create_autocmd('lspattach', {
  callback = function(args)
    local buf = args.buf
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = buf, desc = 'hover' })
    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true}) end, { buffer = buf, desc = 'next diagnostic'})
    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true}) end, { buffer = buf, desc = 'previous diagnostic'})
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { buffer = buf, desc = 'quickfix' })
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
