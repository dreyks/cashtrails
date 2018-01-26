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
    records_data = parse.presence or return
    save
    create_items(records_data)
  end

  def commit
    destroy
  end

  def rollback
    Record.delete(items.pluck(:record_id))
    destroy
  end

  private

  def parse
    importer.call(file.path)
  rescue CSV::MalformedCSVError
    errors.add(:file, 'Not a CSV file')
    nil
  rescue KeyError # => e
    errors.add(:file, 'Header field mismatch')
    nil
  end

  def create_items(records_data)
    records_data.each do |record_data|
      record = Record.new(record_data.merge(kind: Record::KIND_EXPENSE))
      record.source_account = account

      record.save or next

      items << ImporterSessionItem.new(record: record)
    end
  end
end
