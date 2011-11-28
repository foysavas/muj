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

  def self.eval(str,json,opts={})
    require 'v8' unless defined? ::V8
    cxt = ::V8::Context.new
    cxt.load(File.dirname(__FILE__)+"/mustache.js")
    opts['partials'] = '.' unless opts['partials']
    cxt['partials'] = Muj::Partials.new(opts['partials'])
    cxt.eval(%Q{Mustache.to_html("#{str.chomp.gsub("\n",'\n\\').gsub('"','\"')}", #{json}, partials);})
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
