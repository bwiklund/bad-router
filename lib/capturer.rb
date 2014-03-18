# this Capturer lets you do stuff like "/:foo/:bar".
# TODO: named capture groups with regexp

module BadRouter

  class Capturer

    def initialize(str)
      @str = str
      parts = str.split('/')

      regexpParts = parts.map do |part|
        if part[0] == ':'
          "(?<%s>\\w*)" % part[1..-1]
        else
          part
        end
      end

      regexpStr = regexpParts.join("\\/")
      @regexp = Regexp.new regexpStr

    end

    def parse(path)
      matches = @regexp.match path
      Hash[ matches.names.zip( matches.captures ) ]
    end

  end

end