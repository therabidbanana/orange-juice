require 'rubygems'
require '../lib/orange-juice'


class Hello < Orange::Resource
  call_me :hello
  def view(packet, opts = {})
    'Hello World'
  end
end

map(/\//, :hello)
load Hello.new
