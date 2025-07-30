-- Install: `yay -S csharp-ls`
return {
  cmd = { 'csharp-ls' },
  filetypes = { 'cs' },
  root_markers = { '.git' },
  init_options = { AutomaticWorkspaceInit = true }
}
