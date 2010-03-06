require 'orange-juice/application'
Dir.glob(File.join('orange-juice', 'plugins', '*.rb')).each {|f| require f }

module OrangeJuice
end