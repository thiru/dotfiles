---@brief
---
--- https://projects.eclipse.org/projects/eclipse.jdt.ls
---
--- Language server for Java.
---
--- Arch install: `yay -S jdtls`

local work_dir = vim.uv.os_homedir() .. '/.cache/jdtls'

---@type vim.lsp.Config
return {
  cmd = { 'jdtls', '-configuration', work_dir .. '/config', '-data', work_dir ..'/workspace' },
  filetypes = { 'java' },
  root_markers = { '.git', 'build.gradle', 'build.gradle.kts', 'build.xml', 'pom.xml', 'settings.gradle', 'settings.gradle.kts' },
  init_options = {
    jvm_args = {},
    workspace = work_dir .. '/workspace'
  }
}
