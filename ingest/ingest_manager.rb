require 'net/http'
require 'uri'

require 'parser'
require 'spider'
Dir.glob('parsers/*').each {|f| require f}
Dir.glob('spiders/*').each {|f| require f}

class IngestManager
end