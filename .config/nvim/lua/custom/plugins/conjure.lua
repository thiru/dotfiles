local u = require('custom.utils')

return {
  'Olical/conjure',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started(),
  branch = 'main',
  config = function()
    vim.g['conjure#mapping#doc_word'] = {'<localleader>k'}
    vim.g['conjure#log#botright'] = true

    -- Enable tree-sitter support:
    vim.g['conjure#extract#tree_sitter#enabled'] = true

    -- Don't auto-start Babashka REPL
    vim.g['conjure#client#clojure#nrepl#connection#auto_repl#enabled'] = false
  end
}
