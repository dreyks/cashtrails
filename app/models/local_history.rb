class LocalHistory < CashTrailsModel
  self.table_name = 'localHistory'

  def save
    persisted? or return super
    valid? or return

    self.class.where(monthCode: monthCode).update_all(recordCount: recordCount)
  end
end
