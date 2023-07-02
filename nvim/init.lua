local doc = 'Config starting point.'

require('thiru.bootstrap').setup()
require('thiru.plugins').setup()
require('thiru.mappings.core').setup()
require('thiru.mappings.plugins').setup()
require('thiru.settings.core').setup()
require('thiru.settings.plugins').setup()
require('thiru.whitespace').setup()
require('thiru.plain-term').setup()
require('thiru.gui.settings').setup()
require('thiru.gui.mappings').setup()
require('thiru.gui.neovide').setup()

return {
  doc = doc
}
