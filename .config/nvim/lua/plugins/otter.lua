local u = require('config.utils')

return {
  'jmbuhr/otter.nvim',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started(),
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    local otter = require('otter')
    otter.setup()
    if otter then
      vim.keymap.set('n', '<leader>a',
        function()
          otter.activate({'bash', 'javascript'}, true, true, nil)
        end,
        {desc = 'Activate Otter'})
    end
  end
}
