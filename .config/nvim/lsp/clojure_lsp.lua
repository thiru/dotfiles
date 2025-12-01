---@brief
---
--- https://github.com/clojure-lsp/clojure-lsp
---
--- Clojure Language Server
---
--- Arch install: `yay -S clojure-lsp-bin`

---@type vim.lsp.Config
return {
  cmd = { 'clojure-lsp' },
  filetypes = { 'clojure', 'edn' },
  root_markers = { 'deps.edn', 'bb.edn', 'project.clj', '.git' },
}
