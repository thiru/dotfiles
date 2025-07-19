-- Install: `pacman -S deno`
return {
  cmd = { 'deno', 'lsp' },
  cmd_env = { NO_COLOR = true },
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
  root_markers = { 'package.json', 'package.jsonc', 'deno.json', 'deno.jsonc', '.git' },
  settings = {
    deno = {
      enable = true,
      suggest = {
        imports = {
          hosts = {
            ['https://deno.land'] = true
          }
        }
      }
    }
  }
}
