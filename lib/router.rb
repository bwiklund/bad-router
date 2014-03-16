class Route
  attr_reader :handler

  def initialize(methods,regexp,handler)
    @methods = methods
    @regexp = regexp
    @handler = handler
  end

  def matches(env)
    env['PATH_INFO'] =~ @regexp and @methods.include? env['REQUEST_METHOD'].to_sym
  end

  def call(env)
    @handler.call
  end
end


class Router
  def initialize
    @routes = []
  end

  def call(env)
    route = find_first_matching_route env

    if route.nil?
      [404,{},["unacceptable."]]
    else
      route.call env
    end
  end

  def find_first_matching_route(env)
    @routes.detect do |testRoute|
      if testRoute.matches env
        route = testRoute
      end
    end
  end

  # magically generate helpers for http methods
  %i(GET POST PUT PATCH DELETE OPTIONS TRACE CONNECT).each do |method|
    define_method method.downcase do |regexpOrString,&handler|
      regexp = Regexp.new regexpOrString
      @routes << Route.new([method],regexp,handler)
    end
  end
end