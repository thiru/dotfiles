local u = require('mine.utils')

if u.is_windows() or u.diff_mode() or not u.has_rust() then return end

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'parinfer-rust' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd('parinfer-rust') end
      vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path })
    end
  end
})

vim.pack.add({'https://github.com/eraserhd/parinfer-rust'})
