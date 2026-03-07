-- Plugin to improve viewing Markdown files in Neovim
-- https://github.com/MeanderingProgrammer/render-markdown.nvim

return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = 'markdown',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-mini/mini.nvim',
  },
  opts = {},
}
