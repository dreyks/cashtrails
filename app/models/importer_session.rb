require 'csv'

class ImporterSession < ActiveRecord::Base
  attr_accessor :file

  belongs_to :importer
  belongs_to :user
  belongs_to :account
  has_many :items, class_name: 'ImporterSessionItem', dependent: :delete_all

  validates_presence_of :importer, :user, :account, :file

  # before_save :parse
  # after_save :create_items

  def import
    save

    records = parse do |record|
      record.kind = Record::KIND_EXPENSE
      record.source_account = account
    end.compact

    records.each do |record|
      items << ImporterSessionItem.new(record: record)
    end
  end

  def commit
    update_account_balances
    destroy
  end

  def rollback
    Record.delete(items.pluck(:record_id))
    destroy
  end

  private

  def parse
    importer.call(file.path) do |record|
      yield record if block_given?
    end
  rescue CSV::MalformedCSVError
    errors.add(:file, 'Not a CSV file')
    nil
  rescue KeyError # => e
    errors.add(:file, 'Header field mismatch')
    nil
  end

  def update_account_balances
    items.each do |item|
      record = item.record

      source_balance = record.source_account.balances.find_or_initialize_by(currency: record.source_currency) do |b|
        b.amount = 0
      end
      target_balance = if record.transfer?
                         record.target_account.balances.find_or_initialize_by(currency: record.target_currency) do |b|
                           b.amount = 0
                         end
                       end

      source_balance.amount += record.source_amount * 100
      target_balance.amount += record.target_amount * 100 if target_balance

      source_balance.save
      target_balance&.save
    end
  end
end
