require 'rubygems'
require '../../orange/lib/orange-core'
require '../lib/orange-juice'
require 'orange-more/debugger'


class Traffik < Orange::Resource
  call_me :traffik
  def view(packet, opts = {})
    projects = orange[:parser].yaml('traffic.yml')
    packet['template.file'] = 'main.haml'
    packet.add_css('traffic.css')
    orange[:parser].haml('status.haml', packet, {:projects => projects})
  end
end

map(/\//, :traffik)
load Traffik.new
