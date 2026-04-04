local p = require('my.packin')

p.add{
  src = 'https://github.com/nickjvandyke/opencode.nvim',
  name = 'opencode',
  cond = not vim.opt.diff:get(),
  after_load = function(plugin)
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any; goto definition on the type or field for details
    }

    vim.o.autoread = true -- Required for `opts.events.reload`

    -- Recommended/example keymaps
    vim.keymap.set({ 'n', 'x' }, '<leader>aa', function() plugin.ask('@this: ', { submit = true }) end, { desc = 'Ask opencode…' })
    vim.keymap.set({ 'n', 'x' }, '<leader>ax', function() plugin.select() end, { desc = 'Execute opencode action…' })
    vim.keymap.set({ 'n'      }, '<leader>at', function() plugin.toggle() end,{ desc = 'Toggle opencode' })

    vim.keymap.set({ 'n', 'x' }, '<leader>ar',  function() return plugin.operator('@this ') end, { desc = 'Add range to opencode', expr = true })
    vim.keymap.set('n',          '<leader>al', function() return plugin.operator('@this ') .. '_' end, { desc = 'Add line to opencode', expr = true })

    vim.keymap.set('n', '<S-C-u>', function() plugin.command('session.half.page.up') end, { desc = 'Scroll opencode up' })
    vim.keymap.set('n', '<S-C-d>', function() plugin.command('session.half.page.down') end, { desc = 'Scroll opencode down' })
  end,
}
