-- Install: `pacman -S lua-language-server`
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
