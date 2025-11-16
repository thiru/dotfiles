local u = require('config.utils')
local neovide = require('config.neovide')

return {
  'thiru/nvtmux.nvim',
  cond = not vim.opt.diff:get(),
  dev = true,
  depedencies = {'nvim-telescope/telescope.nvim'},
  opts = {
    auto_start = u.nvtmux_auto_started(),
    colorscheme = 'catppuccin-mocha',
    on_tab_changed = function(is_term_tab)
      if vim.g.neovide then
        if is_term_tab then
          if vim.g.neovide_opacity ~= neovide.terminal_opacity_override then
            vim.g.neovide_opacity = neovide.terminal_opacity_override
          end
        else
          if vim.g.neovide_opacity ~= neovide.opacity_default then
            vim.g.neovide_opacity = neovide.opacity_default
          end
        end
      end
    end
  },
}
