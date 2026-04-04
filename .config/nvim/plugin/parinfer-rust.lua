local p = require('my.packin')
local u = require('my.utils')

p.add{
  src = 'https://github.com/eraserhd/parinfer-rust',
  cond = not vim.opt.diff:get() and u.has_rust(),
  --TODO: build = 'cargo build --release',
}
