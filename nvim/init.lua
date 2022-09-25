local doc = 'Config starting point.'

require('thiru.plugins').setup()
require('thiru.mappings.core').setup()
require('thiru.mappings.plugins').setup()
require('thiru.settings.core').setup()
require('thiru.settings.plugins').setup()
require('thiru.line-endings').setup()
require('thiru.plain-term').setup()

return {
  doc = doc
}
