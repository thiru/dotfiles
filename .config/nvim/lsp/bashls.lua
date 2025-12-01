---@brief
---
--- https://github.com/bash-lsp/bash-language-server
---
--- Language server for bash, written using tree sitter in typescript.
---
--- Arch install: `pacman -S bash-language-server`

---@type vim.lsp.Config
return {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'bash', 'sh' },
  root_markers = { '.git' },
  settings = {
    bashIde = {
      globPattern = "*@(.sh|.inc|.bash|.command)"
    }
  }
}
