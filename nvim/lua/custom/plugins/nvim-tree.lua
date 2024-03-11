return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup({
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        vim.keymap.set('n', '-',     api.tree.change_root_to_parent,   opts('Up'))
        vim.keymap.set('n', '.',     api.node.run.cmd,                 opts('Run Command'))
        vim.keymap.set('n', '<C-k>', api.node.show_info_popup,         opts('Info'))
        vim.keymap.set('n', '<CR>',  api.node.open.edit,               opts('Edit Or Open'))
        vim.keymap.set('n', 'D',     api.fs.trash,                     opts('Trash'))
        vim.keymap.set('n', 'E',     api.tree.expand_all,              opts('Expand All'))
        vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,    opts('Toggle Filter: Dotfiles'))
        vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter, opts('Toggle Filter: Git Ignore'))
        vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,        opts('Copy Relative Path'))
        vim.keymap.set('n', 'a',     api.fs.create,                    opts('Create File Or Directory'))
        vim.keymap.set('n', 'bd',    api.marks.bulk.delete,            opts('Delete Bookmarked'))
        vim.keymap.set('n', 'bmv',   api.marks.bulk.move,              opts('Move Bookmarked'))
        vim.keymap.set('n', 'bt',    api.marks.bulk.trash,             opts('Trash Bookmarked'))
        vim.keymap.set('n', 'c',     api.fs.copy.node,                 opts('Copy'))
        vim.keymap.set('n', 'd',     api.fs.remove,                    opts('Delete'))
        vim.keymap.set('n', 'e',     api.fs.rename_basename,           opts('Rename: Basename'))
        vim.keymap.set('n', 'g?',    api.tree.toggle_help,             opts('Help'))
        vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,        opts('Copy Absolute Path'))
        vim.keymap.set('n', 'h',     api.node.navigate.parent,         opts('Close'))
        vim.keymap.set('n', 'l',     api.node.open.edit,               opts('Edit Or Open'))
        vim.keymap.set('n', 'm',     api.marks.toggle,                 opts('Toggle Bookmark'))
        vim.keymap.set('n', 'o',     api.node.open.edit,               opts('Edit Or Open'))
        vim.keymap.set('n', 'p',     api.fs.paste,                     opts('Paste'))
        vim.keymap.set('n', 'r',     api.fs.rename,                    opts('Rename'))
        vim.keymap.set('n', 's',     api.node.run.system,              opts('Run System'))
        vim.keymap.set('n', 'x',     api.fs.cut,                       opts('Cut'))
        vim.keymap.set('n', 'y',     api.fs.copy.filename,             opts('Copy Name'))
      end
    })

    vim.keymap.set('n', '<leader>ff', ':NvimTreeToggle<CR>', { desc = 'Toggle file tree', silent = true })
    vim.keymap.set('n', '<leader>fo', ':NvimTreeFindFile<CR>', { desc = 'Open file tree & focus file', silent = true })
  end
}
