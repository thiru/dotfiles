return {
  'echasnovski/mini.surround',
  cond = not vim.opt.diff:get() and not require('custom.plain-term').is_enabled(),
  version = '*',
  opts = {
    mappings = {
      add = 'gsa', -- Add surrounding in Normal and Visual modes
      delete = 'gsd', -- Delete surrounding
      find = '', -- Find surrounding (to the right)
      find_left = '', -- Find surrounding (to the left)
      highlight = '', -- Highlight surrounding
      replace = 'gsr', -- Replace surrounding
      update_n_lines = 'gsn', -- Update `n_lines`
    },
  },
}
