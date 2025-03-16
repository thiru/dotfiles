--- Alter Neovim to act as a scrollback buffer for the Kitty terminal.
---@see https://vi.stackexchange.com/a/45683

local M = {}

local u = require('custom.utils')

M.init = function()
  if u.is_kitty_scrollback() then
    vim.schedule(function()
      -- Hide status line
      vim.opt.laststatus = 0

      -- Make it easier to quit without prompting for unsaved changes
      vim.keymap.set('n', '<leader>q', '<CMD>qa!<CR>', {desc='Quit!', silent=true})
      vim.keymap.set('n', '<C-c>', '<CMD>qa!<CR>', {silent=true})

      -- Toggle relative line number
      vim.keymap.set({'n', 'v', 't'}, '<C-l>',
        function()
          if vim.wo.relativenumber then
            vim.wo.relativenumber = false
          else
            vim.wo.relativenumber = true
          end
        end,
        {silent=true})

      M.ansi_colourise()

      -- Prevent entering insert mode (which seems to lock up Neovim)
      vim.api.nvim_create_autocmd("TermEnter", {command="stopinsert"})

      -- Go to the last line
      vim.cmd('normal! G$')

      -- Allow modifing the buffer (which isn't allowed by default in :term)
      vim.cmd('set modifiable')

      -- Starting a terminal buffer hides line number columns so we do this here
      vim.wo.relativenumber = true
    end)
  end
end

--- Handle (render) ANSI colours by using Neovim's terminal.
M.ansi_colourise = function()
  local buf = vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  while #lines > 0 and vim.trim(lines[#lines]) == '' do
    lines[#lines] = nil
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
  vim.api.nvim_chan_send(vim.api.nvim_open_term(buf, {}), table.concat(lines, '\r\n'))
end

return M
