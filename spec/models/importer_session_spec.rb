require 'rails_helper'

describe ImporterSession do
  let!(:importer_session) { create(:importer_session, items_count: 3) }

  describe '#commit' do
    it 'removes the session itself' do
      expect { importer_session.commit }.to change { ImporterSession.count }.by -1
    end

    it 'removes all items' do
      expect { importer_session.commit }.to change { ImporterSessionItem.count }.by -3
    end

    it 'does not remove imported records and tags' do
      expect { importer_session.commit }.not_to change { Record.count }
    end
  end

  describe '#rollback' do
    it 'removes the session itself' do
      expect { importer_session.rollback }.to change { ImporterSession.count }.by -1
    end

    it 'removes all items' do
      expect { importer_session.rollback }.to change { ImporterSessionItem.count }.by -3
    end

    it 'removes imported records and tags' do
      expect { importer_session.rollback }.to change { Record.count }.by -3
    end
  end
end
