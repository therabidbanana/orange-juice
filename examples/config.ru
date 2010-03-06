#\-s thin -p 4321

require 'main'
require 'rack'
require 'rack/builder'
require 'rack/abstract_format'
require 'rack/openid'
require 'openid_dm_store'

use Rack::Reloader
run Proc.new{|env| OrangeJuice::MainApp.app.call(env) }
