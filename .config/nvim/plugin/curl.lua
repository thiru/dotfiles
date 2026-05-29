local p = require('my.packin')
local u = require('my.utils')

p.add{
  src = 'https://github.com/oysandvik94/curl.nvim',
  name = 'curl',
  enabled = not u.diff_mode(),
  opts = {
    default_flags = {'--insecure'},
    show_request_duration_limit = 0.5,
  },
}
