---@brief
---
--- https://github.com/mtshiba/pylyzer
---
--- `pylyzer`, a fast static code analyzer & language server for Python.
---
--- Arch install: `yay -S pylyzer-bin erg-bin`

---@type vim.lsp.Config
return {
  cmd = { 'pylyzer', '--server' },
  filetypes = { 'python' },
  root_markers = {
    'setup.py',
    'tox.ini',
    'requirements.txt',
    'Pipfile',
    'pyproject.toml',
    '.git',
  },
  settings = {
    python = {
      diagnostics = true,
      inlayHints = true,
      smartCompletion = true,
      checkOnType = false,
    },
  },
}
