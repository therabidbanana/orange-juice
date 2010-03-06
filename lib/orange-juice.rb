libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
require 'orange-core'
require 'orange-juice/base'

require 'orange-juice/runner'