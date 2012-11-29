require "contextuality/version"
require "contextuality/context"

module Contextuality
  def self.included klass
    klass.class_eval do
      extend ContextualityMethods
      include ContextualityMethods
    end
  end

  module ContextualityMethods
    def contextuality
      ::Thread.current.contextuality
    end
  end

  module ObjectMethods
    def contextualize variables = {}, &block
      ::Thread.current.contextuality.push variables
      result = block.call
      ::Thread.current.contextuality.pop
      result
    end
  end

  module ThreadMethods
    def contextuality
      self[:contextuality] ||= (Thread.main != self) ?
        Thread.main.contextuality.dup :
        Contextuality::Context.new
    end
  end
end

Object.send :include, Contextuality::ObjectMethods
Thread.send :include, Contextuality::ThreadMethods
