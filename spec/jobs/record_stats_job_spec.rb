describe 'RecordStatsJob' do

  context '#perform' do
    let(:link) { create(:link) }
    let(:ip) { "49.147.105.25" }
    let(:ua) { "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:63.0) Gecko/20100101 Firefox/63.0" }

    it 'should create a new viewer record if ip and ua is non existent' do
      expect(Viewer.all.size).to eq(0)
      RecordStatsJob.perform_async(link, ip, ua)
      expect(Viewer.all.size).to eq(1)
      expect(Viewer.first.view_count).to eq(1)
    end

    it 'should increment the count if viewer record is found' do
      expect(Viewer.all.size).to eq(0)
      RecordStatsJob.perform_async(link, ip, ua)
      RecordStatsJob.perform_async(link, ip, ua)
      expect(Viewer.all.size).to eq(1)
      expect(Viewer.first.view_count).to eq(2)
    end
  end
end