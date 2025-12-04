return {
  'nvim-mini/mini.extra',
  version = false,
  opts = {},
  keys = {
    { "<leader>sr", function() MiniExtra.pickers.oldfiles() end, desc = "Search Recent Files" },
    { "<leader>so", function() MiniExtra.pickers.explorer({cwd=vim.uv.os_homedir()}) end, desc = "Search/Open Path" },
  }
}
