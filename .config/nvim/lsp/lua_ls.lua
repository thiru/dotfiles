---@brief
---
--- https://github.com/luals/lua-language-server
---
--- Lua language server.
---
--- Arch install: `pacman -S lua-language-server`

---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  settings = {
    Lua = {
      hint = { enable = true },
      diagnostics = {
        globals = { 'vim' }
      },
      runtime = {
        version = 'LuaJIT'
      },
    }
  }
}
