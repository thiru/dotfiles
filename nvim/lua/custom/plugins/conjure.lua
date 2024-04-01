return {
  'Olical/conjure',
  enabled = function()
    return not is_windows()
  end,
  config = function()
    -- Don't auto-start REPL in diff mode
    if vim.opt.diff:get() then
      vim.g['conjure#client_on_load'] = false
    end

    vim.g['conjure#mapping#doc_word'] = {'<localleader>k'}
    vim.g['conjure#log#botright'] = true

    -- Enable tree-sitter support:
    vim.g['conjure#extract#tree_sitter#enabled'] = true

    -- Don't auto-start Babashka REPL
    vim.g['conjure#client#clojure#nrepl#connection#auto_repl#enabled'] = false
  end
}
