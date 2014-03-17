require 'rack'
require './lib/router'

router = BadRouter::Router.new

router.get "/" do
  [200,{},["hello!"]]
end

Rack::Handler::WEBrick.run( router, Port: 9000 )
