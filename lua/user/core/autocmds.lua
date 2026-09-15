local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_group,
  callback = function(args)
    local buf = args.buf
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = buf, desc = 'Hover Documentation' })

    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true}) end, { buffer = buf, desc = 'Previous diagnostic'})
    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true}) end, { buffer = buf, desc = 'Next diagnostic'})

    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { buffer = buf, desc = 'Diagnostic quickfix' })
  end,
})
