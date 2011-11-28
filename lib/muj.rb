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

  def self.eval(data,json)
    require 'v8' unless defined? ::V8
    cxt = ::V8::Context.new
    cxt.eval('var locals='+json+'; for(var attrname in locals) {this[attrname] = locals[attrname]; }');
    cxt.load(File.dirname(__FILE__)+"/mustache.js")
    cxt.eval(data)
  end

  def self.render(str,locals={})
    self.eval(str,locals.to_json)
  end

  def self.render_with_json(str,json)
    self.eval(str,json)
  end

  def self.render_with_yaml(str,yml)
    require 'yaml' unless defined? YAML
    self.render(str,YAML.load(yml))
  end
end
