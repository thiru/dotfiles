local doc = 'Common/generic functionality.'


local font_size_default = 15


-- Pretty-print lua values including tables
function _G.pp(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    print(unpack(objects))
end


-- NOTE: This must happen before plugins are required (otherwise the wrong leader will be used)
local function set_leader_keys()
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ','
end


return {
  doc = doc,
  font_size_default = font_size_default,
  set_leader_keys = set_leader_keys,
}
