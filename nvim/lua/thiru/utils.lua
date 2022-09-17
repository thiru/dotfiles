local doc = 'Generic, global utilities.'

function is_path_present(x)
  return vim.fn.empty(vim.fn.glob(x)) == 0
end

return {
  doc = doc,
  is_path_present = is_path_present
}
