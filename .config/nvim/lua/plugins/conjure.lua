local function restart_python()
  vim.cmd('ConjurePythonStop')
  vim.cmd('ConjurePythonStart')
end

return {
  'Olical/conjure',
  cond = not vim.opt.diff:get(),
  branch = 'main',
  config = function()
    vim.g['conjure#mapping#doc_word'] = {'<localleader>k'}
    vim.g['conjure#log#botright'] = true

    -- Enable tree-sitter support:
    vim.g['conjure#extract#tree_sitter#enabled'] = true

    -- Don't auto-start Babashka REPL
    vim.g['conjure#client#clojure#nrepl#connection#auto_repl#enabled'] = false
  end,
  keys = {
    {'<localleader>cr', restart_python, ft = 'python', desc = 'Restart Python REPL'}
  }
}
