return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup({
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        vim.keymap.set('n', 'l', api.node.open.edit, opts('Edit Or Open'))
        vim.keymap.set('n', 'o', api.node.open.edit, opts('Edit Or Open'))
        vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Edit Or Open'))
        vim.keymap.set('n', 'h', api.node.navigate.parent, opts('Close'))
      end
    })

    vim.keymap.set('n', '<leader>ff', ':NvimTreeToggle<CR>', { desc = 'Toggle file tree', silent = true })
    vim.keymap.set('n', '<leader>fo', ':NvimTreeFindFile<CR>', { desc = 'Open file tree & focus file', silent = true })
  end
}
