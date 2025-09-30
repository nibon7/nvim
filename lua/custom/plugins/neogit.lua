-- An interactive and powerful Git interface for Neovim, inspired by Magit
-- https://github.com/NeogitOrg/neogit

vim.pack.add {
  'https://github.com/NeogitOrg/neogit',
  'https://github.com/nvim-lua/plenary.nvim', -- required
  'https://github.com/sindrets/diffview.nvim', -- optional - Diff integration
  'https://github.com/nvim-telescope/telescope.nvim', -- optional - Menu selection
}

vim.keymap.set('n', '<leader>g', '<cmd>Neogit<CR>', { desc = 'Neo[g]it', silent = true })
