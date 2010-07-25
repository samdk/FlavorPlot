require 'net/http'
require 'uri'

require 'rubygems'
require 'active_support'

require File.dirname(__FILE__) + '/parser'
require File.dirname(__FILE__) + '/spider'
require File.dirname(__FILE__) + '/../db'

Dir.glob('parsers/*').each {|f| require f}
Dir.glob('spiders/*').each {|f| require f}

class IngestManager
end