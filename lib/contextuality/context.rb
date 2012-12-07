module Contextuality
  class Context
    def initialize
      @scopes = []
    end

    def scope_inspect scope
      scope.map do |name, value|
        "#{name}: #{value.inspect}"
      end.to_a.join(', ')
    end

    def push variables
      @scopes.unshift Hash[variables.map { |(name, variable)| [name.to_s, variable] }]
      Contextuality.log "#{'=' * @scopes.size} Entering scope: #{scope_inspect @scopes.first}"
    end

    def pop
      Contextuality.log "#{'=' * @scopes.size} Exiting scope"
      @scopes.shift
    end

    def [] name
      name = name.to_s
      scope = @scopes.detect { |scope| scope.key? name }
      scope ? scope[name] : Contextuality.defaults[name.to_sym]
    end

    def key? name
      name = name.to_s
      @scopes.any? { |scope| scope.key? name }
    end

    def empty?
      !@scopes.any? { |scope| !scope.empty? }
    end

    def method_missing method, *args, &block
      self[method]
    end
  end
end
