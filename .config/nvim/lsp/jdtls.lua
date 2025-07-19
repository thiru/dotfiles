-- Install: `yay -S jdtls`

local work_dir = vim.uv.os_homedir() .. '/.cache/jdtls'

return {
  cmd = { 'jdtls', '-configuration', work_dir .. '/config', '-data', work_dir ..'/workspace' },
  filetypes = { 'java' },
  root_markers = { '.git', 'build.gradle', 'build.gradle.kts', 'build.xml', 'pom.xml', 'settings.gradle', 'settings.gradle.kts' },
  init_options = {
    jvm_args = {},
    workspace = work_dir .. '/workspace'
  }
}
