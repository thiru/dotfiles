local function restart_python()
  vim.cmd('ConjurePythonStop')
  vim.cmd('ConjurePythonStart')
end

return {
  'Olical/conjure',
  cond = not vim.opt.diff:get(),
  branch = 'main',
  lazy = false,
  config = function()
    vim.g['conjure#mapping#doc_word'] = {'<localleader>k'}
    vim.g['conjure#log#botright'] = true

    -- Enable tree-sitter support:
    vim.g['conjure#extract#tree_sitter#enabled'] = true
  end,
  keys = {
    {'<localleader>cr', restart_python, ft = 'python', desc = 'Restart Python REPL'}
  }
}
