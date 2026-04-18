local p = require('my.packin')
local u = require('my.utils')
local neovide = require('my.neovide')

p.add{
  -- src = 'https://github.com/thiru/nvtmux.nvim',
  src = '~/code/nvtmux.nvim',
  name = 'nvtmux',
  enabled = not u.diff_mode(),
  opts = function(plugin)
    vim.keymap.set({'n', 'v', 't'}, '<C-CR>', plugin.new_tab, {desc = 'New terminal tab'})
    vim.keymap.set('n', '<leader>f', plugin.new_float_term, {desc = 'New terminal float'})

    return {
      auto_start = u.nvtmux_auto_started(),
      colorscheme = 'catppuccin-mocha',
      -- HACK: terminal colours aren't set correctly without this
      on_before_term_created = function()
        vim.cmd('set background=dark')
      end,
      on_tab_changed = function(is_term_tab)
        if vim.g.neovide then
          if is_term_tab then
            if vim.g.neovide_opacity ~= neovide.terminal_opacity_override then
              vim.g.neovide_opacity = neovide.terminal_opacity_override
            end
          else
            -- NOTE: undo terminal hack above (on_before_term_created)
            vim.cmd('set background=light')
            if vim.g.neovide_opacity ~= neovide.opacity_default then
              vim.g.neovide_opacity = neovide.opacity_default
            end
          end
        end
      end
    }
  end
}
