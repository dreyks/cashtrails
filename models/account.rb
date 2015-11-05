class Account < ActiveRecord::Base
  has_many :balances, class_name: 'AccountBalance', foreign_key: :accountIDOrInvalid
  belongs_to :account_group, foreign_key: :accountGroupIDOrInvalid

  def multicurrency?
    currencyIDOrInvalid.zero?
  end

  def balance
    balances.first
  end

  def to_s
    name
  end
end