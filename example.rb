require 'rack'
require './lib/router'

router = Router.new

router.get "/" do
  [200,{},["hello!"]]
end

Rack::Handler::WEBrick.run( router, Port: 9000 )
