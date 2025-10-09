-- Rainbow delimiters for Neovim with Tree-sitter
-- https://github.com/HiPhish/rainbow-delimiters.nvim

return {
  'HiPhish/rainbow-delimiters.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
}
