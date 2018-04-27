module Type
  class ZeroedNil < SimpleDelegator
    alias_method :subtype, :__getobj__

    def initialize(subtype)
      self.__setobj__(subtype)
    end

    def deserialize(value)
      value = subtype.deserialize(value)

      value&.zero? or return value

      nil
    end

    def serialize(value)
      value = subtype.serialize(value)

      value.nil? or return value

      0
    end
  end
end
