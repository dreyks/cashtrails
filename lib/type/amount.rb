module Type
  class Amount < ActiveModel::Type::Float
    def type
      :amount
    end

    def deserialize(value)
      super.to_f / 100
    end

    def serialize(value)
      (super.to_f * 100).round
    end
  end
end
