local doc = 'Common globals.'

local function is_quick_edit_mode()
  return vim.g.quick_edit_mode == true
end

return {
  doc,
  is_quick_edit_mode = is_quick_edit_mode
}
