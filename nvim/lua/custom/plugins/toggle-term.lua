return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup({
      direction = 'float',
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,
    })
    vim.keymap.set('n', '<leader>tl', ':ToggleTermSendCurrentLine<CR>', { desc = 'Send current line to terminal' })
    vim.keymap.set('v', '<leader>tl', ':ToggleTermSendVisualLines<CR>', { desc = 'Send visual lines to terminal' })
    vim.keymap.set('v', '<leader>ts', ':ToggleTermSendVisualSelection<CR>', { desc = 'Send visual selection to terminal' })


    local Terminal  = require('toggleterm.terminal').Terminal
    local cwd_term = Terminal:new({
      on_create = function()
        vim.cmd('sleep 300m') -- HACK: waiting for shell to be ready
        vim.cmd('call chansend(b:terminal_job_id, "cd ' .. vim.loop.cwd() .. ' && clear \\<cr>")')
      end
    })

    function CwdTermToggle()
      cwd_term:toggle()
    end

    vim.api.nvim_set_keymap('n', '<C-t>', '<cmd>lua CwdTermToggle()<CR>', {desc = 'Open terminal in CWD', noremap = true, silent = true})
  end
}
