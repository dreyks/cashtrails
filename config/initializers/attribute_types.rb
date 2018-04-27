require 'type/amount'
require 'type/zeroed_nil'

ActiveRecord::Type.register(:amount, Type::Amount)
ActiveRecord::Type.add_modifier({zeroed_nil: true}, Type::ZeroedNil)
