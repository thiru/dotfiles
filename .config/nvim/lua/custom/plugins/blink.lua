local u = require('custom.utils')

return {
  'saghen/blink.cmp',
  cond = not vim.opt.diff:get() and not u.nvtmux_auto_started(),
  lazy = false, -- lazy loading handled internally
  -- use a release tag to download pre-built binaries
  version = 'v0.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
       ['<C-k>'] = { 'select_prev', 'fallback' },
       ['<C-j>'] = { 'select_next', 'fallback' },
    },

    appearance = {
      use_nvim_cmp_as_default = false,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    completion = {
      accept = {
        -- experimental auto-brackets support
        auto_brackets = { enabled = true }
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      }
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, via `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    signature = { enabled = true }
  },
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.default" }
}
