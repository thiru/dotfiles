local doc = 'Generic, global utilities.'

-- Pretty-print lua values including tables
local function pp(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    print(unpack(objects))
end

local function is_path_present(x)
  return vim.fn.empty(vim.fn.glob(x)) == 0
end

return {
  doc = doc,
  pp = pp,
  is_path_present = is_path_present
}
