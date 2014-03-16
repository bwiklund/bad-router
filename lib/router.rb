class Route
  attr_reader :handler

  def initialize(methods,regexp,handler)
    @methods = methods
    @regexp = regexp
    @handler = handler
  end

  def matches(env)
    env[:REQUEST_PATH] =~ @regexp and @methods.include? env[:REQUEST_METHOD].to_sym
  end
end


class Router
  def initialize
    @routes = []
  end

  def call(env)
    route = find_first_matching_route env

    if route.nil?
      [404,{},"unacceptable."]
    else
      route.handler.call
    end
  end

  def find_first_matching_route(env)
    route = nil
    @routes.each do |testRoute|
      if testRoute.matches env
        route = testRoute
        break
      end
    end
    route
  end

  # helper for brevity
  def get(regexpOrString,&handler)
    regexp = Regexp.new regexpOrString
    @routes << Route.new([:GET],regexp,handler)
  end

  def post(regexpOrString,&handler)
    regexp = Regexp.new regexpOrString
    @routes << Route.new([:POST],regexp,handler)
  end
end