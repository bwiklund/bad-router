module BadRouter
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
      if @mode == :EXCLUDE then matches_method ^= 1 end
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
      @routes.detect { |testRoute| testRoute.matches env }
    end

    def add_route(route)
      @routes << route
    end

    # magically generate helpers for http methods
    %i(GET POST PUT PATCH DELETE OPTIONS TRACE CONNECT).each do |method|
      define_method method.downcase do |regexp,&handler|
        add_route Route.new([method],:INCLUDE,regexp,handler)
      end
    end

    def methods(methods,regexp,&handler)
      add_route Route.new(methods,:INCLUDE,regexp,handler)
    end

    def all(regexp,&handler)
      add_route Route.new([],:EXCLUDE,regexp,handler)
    end

    def except(methods,regexp,&handler)
      add_route Route.new(methods,:EXCLUDE,regexp,handler)
    end
  end
end