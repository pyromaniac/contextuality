module Contextuality
  class Defaults < Hash
    def [] key
      value = super key.to_sym
      value.respond_to?(:call) ? value.call : value
    end

    def []= key, value
      super key.to_sym, value
    end
  end
end
