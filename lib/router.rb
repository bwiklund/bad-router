class Route
  def initialize(methods,mode,regexp,handler)
    @methods = methods
    @mode = mode
    @regexp = if regexp.class == String
      Regexp.new "^" + regexp + "$"
    else
      regexp
    end
    @handler = handler
  end

  def matches(env)
    matches_path = env['PATH_INFO'] =~ @regexp
    matches_method = @methods.include? env['REQUEST_METHOD'].to_sym
    @mode == :EXCLUDE and matches_method ^= 1
    matches_path and matches_method
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
    define_method method.downcase do |regexp,&handler|
      @routes << Route.new([method],:INCLUDE,regexp,handler)
    end
  end

  def methods(methods,regexp,&handler)
    @routes << Route.new(methods,:INCLUDE,regexp,handler)
  end

  def all(regexp,&handler)
    @routes << Route.new([],:EXCLUDE,regexp,handler)
  end

  def except(methods,regexp,&handler)
    @routes << Route.new(methods,:EXCLUDE,regexp,handler)
  end
end