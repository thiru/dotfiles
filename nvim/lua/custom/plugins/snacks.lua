local u = require('custom.utils')

---@module "snacks"

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = not u.nvtmux_auto_started() },
    dashboard = {
      enabled = not u.nvtmux_auto_started(),
      preset = {
        keys = {
          { icon = " ", key = "d", desc = "Directory Picker", action = ":ene | :Telescope cder" },
          { icon = " ", key = "n", desc = "File | New", action = ":ene | startinsert" },
          { icon = " ", key = "f", desc = "File | Picker", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "r", desc = "File | Recent", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = "? ", key = "h", desc = "Help", action = ":lua require('telescope.builtin').help_tags()" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      }
    },
    image = {},
    notifier = {
      enabled = true,
      timeout = 2000,
    },
    quickfile = { enabled = not u.nvtmux_auto_started() },
    picker = {},
    statuscolumn = { enabled = not u.nvtmux_auto_started() },
    styles = {
      notification = {
        wo = { wrap = true } -- Wrap notifications
      }
    }
  },
  keys = {
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>,",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>d",  function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>D",  function() Snacks.bufdelete({force = true}) end, desc = "Delete Buffer (even if modified)" },
    { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<leader>fr", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gB", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gr", function() Snacks.gitbrowse() end, desc = "Git Browse Repo" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>sb", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sc", function() Snacks.picker.commands() end, desc = "Search Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Search Buffer Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = "Search All Diagnostics" },
    { "<leader>sf", function() Snacks.picker.files({follow = true}) end, desc = "Search Files" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Search Help" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Search Keymaps" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Search Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Search Man Pages" },
    { "<leader>sr", function() Snacks.picker.recent() end, desc = "Search Recent Files" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume Previous Search" },
    { "<leader>sv", function() Snacks.picker.files({cwd = vim.fn.stdpath("config")}) end, desc = "Search Config Files" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep Word or Visual Selection" },
    { "<leader>sx", function() Snacks.picker.command_history() end, desc = "Search Command History" },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
      end,
    })
  end,
}
