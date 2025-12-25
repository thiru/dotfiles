---@module 'mini.pick'

local u = require('config.utils')

local fd = {'fd', '--exclude', '.git',
                  '--follow',
                  '--hidden',
                  '--type', 'file',
                  '--type', 'symlink'}

return {
  'nvim-mini/mini.pick',
  cond = not vim.opt.diff:get(),
  version = false,
  opts = {
    mappings = {
      choose_marked = '<C-CR>',
      mark = '<Tab>',
      move_down = '<C-j>',
      move_start = '<C-g>',
      move_up = '<C-k>',
      paste = '<C-v>',
      toggle_preview = '<C-Tab>',
    }
  },
  keys = {
    { '<leader>sb', function() MiniPick.builtin.buffers() end, desc = 'Search Buffers' },
    { '<leader>sf', function() MiniPick.builtin.cli({command=fd}) end, desc = 'Search Files' },
    { '<leader>sh', function() MiniPick.builtin.help() end, desc = 'Search Help' },
    { '<leader>sR', function() MiniPick.builtin.resume() end, desc = 'Resume latest picker' },
    { '<leader>st', function() MiniPick.builtin.grep_live() end, desc = 'Search Text (live)' },
    { '<leader>sv',
      function()
        MiniPick.builtin.cli({command = fd},
                             {source = {cwd = vim.fn.stdpath("config")}})
      end,
      desc = 'Search Neovim Configs' },
    { '<leader>sw',
      function()
        local mode = vim.fn.mode()
        local text = ''
        if mode == 'v' or mode == 'V' then
            text = u.selected_text()
        else
            text = vim.fn.expand('<cword>')
        end
        MiniPick.builtin.grep({pattern=text})
      end,
      mode = {'n','v'},
      desc = 'Search Word/Highlight' },
  }
}
