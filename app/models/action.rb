class Action < ApplicationRecord
  enum effect: {
    source_account: 'source_account',
    target_account: 'target_account',
    tag: 'tag',
    party: 'party',
    remove: 'remove'
  }

  belongs_to :rule
end
