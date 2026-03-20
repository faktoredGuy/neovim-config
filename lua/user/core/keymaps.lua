local map = vim.keymap.set

-- barbar
map('n', '<c-,>', '<cmd>BufferPrevious<cr>', { desc = 'previous buffer' })
map('n', '<c-.>', '<cmd>BufferNext<cr>', { desc = 'next buffer' })
map('n', '<c-1>', '<cmd>BufferGoto 1<cr>', { desc = 'buffer 1' })
map('n', '<c-2>', '<cmd>BufferGoto 2<cr>', { desc = 'buffer 2' })
map('n', '<c-3>', '<cmd>BufferGoto 3<cr>', { desc = 'buffer 3' })
map('n', '<c-4>', '<cmd>BufferGoto 4<cr>', { desc = 'buffer 4' })
map('n', '<c-5>', '<cmd>BufferGoto 5<cr>', { desc = 'buffer 5' })
map('n', '<c-6>', '<cmd>BufferGoto 6<cr>', { desc = 'buffer 6' })
map('n', '<c-7>', '<cmd>BufferGoto 7<cr>', { desc = 'buffer 7' })
map('n', '<c-8>', '<cmd>BufferGoto 8<cr>', { desc = 'buffer 8' })
map('n', '<c-9>', '<cmd>BufferGoto 9<cr>', { desc = 'buffer 9' })
map('n', '<c-0>', '<cmd>BufferLast<cr>', { desc = 'last buffer' })
map('n', '<c-w>', '<cmd>BufferClose<cr>', { desc = 'close buffer' })

-- neo-tree
map('n', '<leader>e', '<cmd>Neotree toggle<cr>', { desc = 'explorer neotree' })

-- terminal
map('n', '<c-q>', '<cmd>ToggleTerm<cr>', { desc = 'toggle terminal' })
map('t', '<C-q>', '<cmd>ToggleTerm<cr>', { noremap = true, silent = true })

map('n', '<leader>cd', function()
  local dir = require("user.utils.project").get_project_root()
  if dir == '' then return end
  vim.notify("sync terminals to: " .. dir)
  local terminals = require("toggleterm.terminal")
  for _, term in ipairs(terminals.get_all()) do
    if term:is_open() then
      vim.api.nvim_chan_send(term.job_id, "cd " .. vim.fn.shellescape(dir) .. "\n")
    end
  end
end, { desc = 'sync terminal to current file directory' })
