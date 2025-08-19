local function init()
  -- Don't enable LSP when diffing
  if vim.opt.diff:get() then
    return
  end

  vim.lsp.enable('bashls', true)
  vim.lsp.enable('clojure_lsp', true)
  vim.lsp.enable('csharp_ls', true)
  vim.lsp.enable('cssls', true)
  vim.lsp.enable('html', true)
  vim.lsp.enable('jdtls', true)
  vim.lsp.enable('jsonls', true)
  vim.lsp.enable('lua_ls', true)
  vim.lsp.enable('pyright', true)
  vim.lsp.enable('ts_ls', true)

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client and client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        local msg = 'Attached LSP server **' .. client.name .. '**'
        vim.notify_once(msg, vim.log.levels.INFO)
      end
    end,
  })
end

return {
  init = init
}
