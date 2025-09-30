-- An interactive and powerful Git interface for Neovim, inspired by Magit
-- https://github.com/NeogitOrg/neogit

return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional - Diff integration
    'nvim-telescope/telescope.nvim', -- optional - Menu selection
  },
  keys = {
    { '<leader>g', '<cmd>Neogit<CR>', desc = 'Neo[g]it', silent = true },
  },
}
