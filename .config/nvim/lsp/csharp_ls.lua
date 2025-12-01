---@brief
---
--- https://github.com/razzmatazz/csharp-language-server
---
--- Language Server for C#.
---
--- csharp-ls requires the [dotnet-sdk](https://dotnet.microsoft.com/download) to be installed.
---
--- Arch install: `yay -S csharp-ls`

---@type vim.lsp.Config
return {
  cmd = { 'csharp-ls' },
  filetypes = { 'cs' },
  root_markers = { '.git' },
  init_options = { AutomaticWorkspaceInit = true }
}
