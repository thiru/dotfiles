return {
  'nvim-neo-tree/neo-tree.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons'
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>ff', ':Neotree toggle reveal<CR>', desc = 'File Tree - Toggle visibility' }
  },
  config = function()
    require('neo-tree').setup({
      filesystem = {
        follow_current_file = {enabled = true},
        use_libuv_file_watcher = true
      },
      window = {
        mappings = {
          ['<CR>'] = 'open',
          ['o'] = 'open',
          ['O'] = 'alt_open',
        }
      },
      commands = {
        alt_open = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()

          if node.type == 'directory' then
            local children = node:get_child_ids()
            for _, cp in ipairs(children) do
              if vim.fn.isdirectory(cp) == 0 then
                vim.cmd('e ' .. cp)
              end
            end
          else
            vim.fn.jobstart({ "xdg-open", path }, { detach = true })
          end
        end
      }
    })
  end
}
