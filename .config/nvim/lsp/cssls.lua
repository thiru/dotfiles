---@brief
---
--- https://github.com/hrsh7th/vscode-langservers-extracted
---
--- Arch install: `pacman -S vscode-css-languageserver`

---@type vim.lsp.Config
return {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_markers = { 'package.json', '.git' },
  init_options = {
    provideFormatter = true
  },
  settings = {
    css = { validate = true },
    less = { validate = true },
    scss = { validate = true }
  }
}
