require 'csv'

class ImporterSession < ActiveRecord::Base
  attr_accessor :file

  belongs_to :importer
  belongs_to :user
  belongs_to :account
  has_many :importer_session_items

  validates_presence_of :importer, :user, :account, :file

  before_save :parse
  after_save :create_items

  private

  attr_accessor :parsed_data

  def parse
    self.parsed_data = importer.call(file.path)
    true
  rescue CSV::MalformedCSVError
    errors.add(:file, 'Not a CSV file')
    false
  rescue KeyError # => e
    errors.add(:file, 'Header field mismatch')
    false
  end

  def create_items
    parsed_data.each do |item_data|
      item = importer_session_items.new
      record = Record.new(importer.parse_record_data(item_data))
      record.source_account = account

      next unless record.save

      item.record = record
      item.save
    end
  end
end
