describe 'Link' do

  context '#find_or_create' do
    let(:valid_url) { "http://test.com" }
    let(:url_digest) { Digest::MD5.new.update(valid_url).hexdigest}

    it 'should create a new record if link is non existing' do
      expect(Link.all.size).to eq(0)
      Link.find_or_create(valid_url)
      expect(Link.all.size).to eq(1)
    end

    it 'should return a the existing link if found' do
      create(:link, original: valid_url, url_digest: url_digest)
      Link.find_or_create(valid_url)
      expect(Link.all.size).to eq(1)
    end

    it 'should not save an empty link' do
      Link.find_or_create('')
      expect(Link.all.size).to eq(0)
    end
  end

  context '#normalize_url' do

    it 'should normalize characters and symbols in the url' do
      nurl = Link.normalize_url("http://www.詹姆斯.com/")
      expect(nurl).to eq("http://www.xn--8ws00zhy3a.com/")
    end

    it 'should append http by default if schema is not found' do
      nurl = Link.normalize_url("www.google.com")
      expect(nurl).to eq("http://www.google.com/")
    end

    it 'should return nil if it received nil' do
      nurl = Link.normalize_url(nil)
      expect(nurl).to eq(nil)
    end

    it 'should return nil for empty string' do
      nurl = Link.normalize_url('')
      expect(nurl).to eq(nil)
    end

    it 'should return nil for invalid url' do
      nurl = Link.normalize_url('xhr://test.com')
      expect(nurl).to eq(nil)
    end
  end

end