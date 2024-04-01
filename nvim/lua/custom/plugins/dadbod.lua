return {
  'kristijanhusak/vim-dadbod-ui',
  enabled = function()
    return not vim.opt.diff:get()
  end,
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion',
      ft = { 'sql', 'mysql', 'plsql' },
      lazy = true },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  keys = {
    {'<leader><CR>',
      function()
        -- HACK: If we're on the last line with no new lines below then `Vip` fails and aborts the rest of the command
        if vim.fn.line('.') == vim.fn.line('$') then
          vim.api.nvim_input('V')
        else
          vim.api.nvim_input('Vip')
        end

        vim.api.nvim_input(':<Plug>(DBUI_ExecuteQuery)')
      end,
      mode = 'n', ft = 'sql', desc = 'Execute SQL query (paragraph)'},
    {'<leader><CR>', '<Plug>(DBUI_ExecuteQuery)', mode = 'v', ft = 'sql', desc = 'Execute SQL query (selected)'}
  },
  config = function()
    vim.g.db_ui_execute_on_save = 0
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_use_nvim_notify = 1

    local function db_completion()
      require("cmp").setup.buffer { sources = { { name = "vim-dadbod-completion" } } }
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "sql",
      },
      command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "sql",
        "mysql",
        "plsql",
      },
      callback = function()
        vim.schedule(db_completion)
      end,
    })
  end,
}
