require 'yaml'
require 'tilt' unless defined? Tilt
require 'json' unless defined? JSON

module Tilt
  class MujTemplate < Template
    def initialize_engine
    end

    def prepare
    end

    def evaluate(scope, locals, &block)
      Muj.eval(data,locals.to_json)
    end
  end
  register 'muj', MujTemplate
end

module Muj
  class Partials
    def initialize(dir)
      @dir = File.expand_path(dir)
    end
    
    def __exists(name)
      fname = name.gsub('>','/')
      File.exists?("#{@dir}/#{fname}.muj")
    end

    def __read(name)
      fname = name.gsub('>','/')
      f = File.open("#{@dir}/#{fname}.muj")
      r = f.read.chomp
      f.close
      r
    end
  end

  def self.escape_template(v)
    v.
      gsub("\n",'\n').
      gsub('"','\"')
  end

  def self.eval(str,json,opts={})
    unless (defined? ::Rhino) || (defined? ::V8)
      begin
        require 'rhino'
      rescue LoadError
        begin
          require 'v8'
        rescue LoadError
          raise LoadError, "V8 (therubyracer) or Rhino (therubyrhino) needed." 
        end
      end
    end
    if (defined?(::Rhino) && defined?(::Rhino::Context))
      cxt = ::Rhino::Context.new
    elsif (defined? ::V8)
      cxt = ::V8::Context.new
    end
    mustachejs_file = File.open(File.dirname(__FILE__)+"/mustache.js")
    cxt.eval(mustachejs_file.read)
    mustachejs_file.close
    opts['views'] = '.' unless opts['views']
    cxt['partials'] = Muj::Partials.new(opts['views'])
    cxt.eval("var locals = #{json};")
    r = cxt.eval(%Q{locals.__yield__ = Mustache.to_html("#{Muj.escape_template(str)}", locals, partials);})
    if opts['layout']
      layout = cxt['partials'].__read(opts['layout'])
      r = cxt.eval(%Q{Mustache.to_html("#{Muj.escape_template(layout)}", locals, partials);})
    end
    r
  end

  def self.render(str,locals={},opts={})
    self.eval(str,locals.to_json,opts)
  end

  def self.render_with_json(str,json,opts={})
    self.eval(str,json,opts)
  end

  def self.render_with_yaml(str,yml,opts={})
    self.render(str,YAML::load(yml),opts)
  end
end
