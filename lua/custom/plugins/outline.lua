-- Fancy code outline sidebar to visualize and navigate code symbols in a tree hierarchy
-- https://github.com/hedyhli/outline.nvim

vim.pack.add { 'https://github.com/hedyhli/outline.nvim' }

require('outline').setup {
  outline_window = {
    position = 'left',
    auto_jump = false,
  },
  outline_items = {
    show_symbol_lineno = true,
  },
  preview_window = {
    auto_preview = false,
  },
  auto_width = {
    enabled = true,
  },
}

vim.keymap.set('n', '<leader>o', '<cmd>Outline<CR>', { desc = 'Toggle [O]utline' })
