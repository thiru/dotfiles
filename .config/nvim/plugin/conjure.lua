local function conjure_setup()
  vim.g['conjure#log#botright'] = true

  -- NOTE: without this Conjure will take over the 'K' key
  vim.g['conjure#mapping#doc_word'] = {'<localleader>d'}

  -- Enable tree-sitter support:
  vim.g['conjure#extract#tree_sitter#enabled'] = true

  vim.pack.add({'https://github.com/Olical/conjure'})

  vim.keymap.set('n', '<localleader>cr',
    function()
      vim.cmd('ConjurePythonStop')
      vim.cmd('ConjurePythonStart')
    end,
    {desc = 'Restart Python REPL'})
end

-- NOTE: only load Conjure plugin explicitly due to odd/unwanted behaviour in some contexts
vim.keymap.set('n', '<leader>co', conjure_setup, {desc = 'Load Conjure'})
