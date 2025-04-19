return {
  'folke/noice.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('noice').setup({
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        long_message_to_split = true, -- long messages will be sent to a split
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
      messages = {
        enabled = false
      },
    })
  end
}
