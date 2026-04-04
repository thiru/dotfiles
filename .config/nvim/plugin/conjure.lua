local function restart_python()
  vim.cmd('ConjurePythonStop')
  vim.cmd('ConjurePythonStart')
end

if not vim.opt.diff:get() then
  vim.g['conjure#mapping#doc_word'] = {'<localleader>k'}
  vim.g['conjure#log#botright'] = true

  -- Enable tree-sitter support:
  vim.g['conjure#extract#tree_sitter#enabled'] = true

  vim.keymap.set('n', '<localleader>cr', restart_python, {desc = 'Restart Python REPL'})

  vim.pack.add({'https://github.com/Olical/conjure'})
end
