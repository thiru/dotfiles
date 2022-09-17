local doc = 'Config starting point.'

require('thiru.plugins').setup()
require('thiru.mappings.builtins').setup()
require('thiru.mappings.plugins').setup()
require('thiru.settings.builtins').setup()
require('thiru.settings.plugins').setup()

return {
  doc = doc
}
