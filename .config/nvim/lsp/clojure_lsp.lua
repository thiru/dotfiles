-- Install: `yay -S clojure-lsp-bin`
return {
  cmd = { 'clojure-lsp' },
  filetypes = { 'clojure', 'edn' },
  root_markers = { 'deps.edn', 'bb.edn', 'project.clj', '.git' },
}
