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

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp", "odin", "qml" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
  end,
})
