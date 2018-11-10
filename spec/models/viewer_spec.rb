describe 'Viewer' do

  context "#md5" do
    let(:ip) { "49.147.105.25" }
    let(:ua) { "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:63.0) Gecko/20100101 Firefox/63.0" }
    let(:digest) { "f285a64f36740395778a20d7b23d84f5" }

    it 'should return a digest of both the ip and ua' do
      expect(Viewer.md5(ip, ua)).to eq(digest)
    end
  end
end