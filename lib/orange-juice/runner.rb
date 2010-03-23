module OrangeJuice
  class MainApp < OrangeJuice::Application
    extend ClassInheritableAttributes
    cattr_accessor :routes, :resources
    def stack_init
      self.class.resources ||= []
      self.class.resources.each{|r| @core.load(r) if r.kind_of?(Orange::Resource)}
    end
    
    
    def call(env)
      packet = Orange::Packet.new(@core, env)
      self.route(packet)
      packet.finish
    end
    
    def route(packet)
      path = packet['route.path'] || packet.request.path_info
      self.class.routes.each{|key,val|
        if path =~ key
          r = val[:resource]
          packet['route.resource'] = r
          packet['route.resource_id'] = val[:resource_id]
          packet['route.resource_action'] = val[:resource_action]
          packet['route.resource_path'] = path.gsub(key, '')
          packet[:content] = (orange[r].view packet) 
        end
      }
    end
  
    def self.map(matcher, resource, opts = {})
      self.routes ||= {}
      opts[:resource] = resource
      self.routes[matcher] = opts
    end
    
    def self.load(resource)
      self.resources ||= []
      self.resources.unshift(resource)
    end
    stack do
    
      use Rack::CommonLogger
      use Rack::MethodOverride
      use Rack::Session::Cookie, :secret => 'orange_secret'

      auto_reload!
      use_exceptions
    
      use Rack::OpenID, OpenIDDataMapper::DataMapperStore.new
      prerouting :multi => false

      routing :single_user => false
    
      postrouting
      run OrangeJuice::MainApp.new(orange)
    end
  end
end

def stack(&block)
  OrangeJuice::MainApp.stack(&block)
end

def map(matcher, resource, opts = {})
  OrangeJuice::MainApp.map(matcher, resource, opts)
end

def load(resource)
  OrangeJuice::MainApp.load(resource)
end