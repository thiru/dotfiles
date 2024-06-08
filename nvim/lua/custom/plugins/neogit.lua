return {
  'NeogitOrg/neogit',
  cond = not vim.opt.diff:get() and not require('custom.plain-term').is_enabled(),
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim', -- optional
    'sindrets/diffview.nvim', -- optional - Diff integration
  },
  config = true,
  keys = {
    {'<leader>gs', ':Neogit<CR>', desc = 'Git status'},
    {'<leader>gb', function () require('neogit').open({ 'branch' }) end, desc = 'Git branch'},
    {'<leader>gl', function () require('neogit').open({ 'log' }) end, desc = 'Git log'},
    {'<leader>gd', ':DiffviewOpen<CR>', desc = 'Git diff view'}
  }
}
