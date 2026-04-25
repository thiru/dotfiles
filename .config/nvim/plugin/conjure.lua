local u = require('my.utils')

local function restart_python()
  vim.cmd('ConjurePythonStop')
  vim.cmd('ConjurePythonStart')
end

if not u.diff_mode() then
  vim.g['conjure#log#botright'] = true

  -- NOTE: without this Conjure will take over the 'K' key
  vim.g['conjure#mapping#doc_word'] = {'<localleader>d'}

  -- Enable tree-sitter support:
  vim.g['conjure#extract#tree_sitter#enabled'] = true

  vim.keymap.set('n', '<localleader>cr', restart_python, {desc = 'Restart Python REPL'})

  vim.pack.add({'https://github.com/Olical/conjure'})
end
