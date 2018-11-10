describe Api::V1::StatsController do
  let(:link) { create(:link) }
  let(:viewers) { [create(:viewer, link_id: link.id, browser: "Chrome", os: "Windows", country: "SG", city: "Singapore"),
                   create(:viewer, viewer_digest: "16132a757bc07b543ee80384ace94a8a", link_id: link.id),
                   create(:viewer, viewer_digest: "3997ca32fd83bf703e8e7d2e4a3ab2d2", link_id: link.id)]}

  shared_examples "a call with invalid code" do
    it 'should return status code 404' do
      get endpoint, params: {code: code}
      expect(response.status).to eq(404)
    end

    it 'should return a json message' do
      get endpoint, params: {code: code}
      expect(response.body).to include_json(message: "Code not found",
                                            code: code,
                                            api_version: "v1")
    end
  end

  shared_examples "a valid request" do
    it 'should return status code 200' do
      get endpoint, params: { code: link.code }
      expect(response.status).to eq(200)
    end
  end

  shared_examples "a call with no db access" do
    it 'should return status code 500' do
      allow_any_instance_of(ActiveRecord::FinderMethods).to receive(:find_by).and_raise("DB connection issues")
      get endpoint, params: { code: link.code }
      expect(response.status).to eq(500)
    end

    it 'should return a valid json response' do
      allow_any_instance_of(ActiveRecord::FinderMethods).to receive(:find_by).and_raise("DB connection issues")
      get endpoint, params: { code: link.code }
      expect(response.body).to include_json(message: "Something went wrong with the system",
                                            code: link.code,
                                            api_version: "v1")
    end
  end

  context '#show' do
    let(:endpoint) { :show }

    it_behaves_like "a call with no db access"

    context 'Invalid Code' do
      let(:code) { "123456" }
      it_behaves_like "a call with invalid code"
    end

    context 'Valid Code' do
      it_behaves_like 'a valid request'

      it 'should return the correct stats' do
        viewers # Create the viewers
        get endpoint, params: { code: link.code }
        expect(response.body).to include_json(message: "Success",
                                              code: link.code,
                                              api_version: "v1")
        data = JSON.parse(response.body)["data"]
        expect(data["total_view_count"]).to eq(3)
        expect(data["unique_viewers"]).to eq(3)
        expect(data["browsers"]["Firefox"]).to eq(2)
        expect(data["os"]["Macintosh"]).to eq(2)
        expect(data["countries"]["PH"]).to eq(2)
        expect(data["cities"]["Cebu"]).to eq(2)
      end
    end
  end

  context "#viewers" do
    let(:endpoint) { :viewers }

    it_behaves_like "a call with no db access"

    context 'Invalid Code' do
      let(:code) { "123456" }
      it_behaves_like "a call with invalid code"
    end

    context "Valid Code" do
      it_behaves_like 'a valid request'

      it 'should return a list of viewers' do
        viewers
        get endpoint, params: { code: link.code }
        expect(response.body).to include_json(message: "Success",
                                              code: link.code,
                                              api_version: "v1")
        data = JSON.parse(response.body)["data"]
        expect(data["viewers"].size).to eq(3)
      end
    end
  end

  context "#viewers_by_country" do
    let(:endpoint) { :viewers_by_country }

    it_behaves_like "a call with no db access"

    context 'Invalid Code' do
      let(:code) { "123456" }
      it_behaves_like "a call with invalid code"
    end

    context "Valid Code" do
      it_behaves_like 'a valid request'

      it 'should return a list of viewers from the specified country' do
        viewers
        get endpoint, params: { code: link.code, country: "PH" }
        expect(response.body).to include_json(message: "Success",
                                              code: link.code,
                                              api_version: "v1")
        data = JSON.parse(response.body)["data"]
        expect(data["viewers"].size).to eq(2)
      end
    end
  end

  context "#viewers_by_browser" do
    let(:endpoint) { :viewers_by_browser }

    it_behaves_like "a call with no db access"

    context 'Invalid Code' do
      let(:code) { "123456" }
      it_behaves_like "a call with invalid code"
    end

    context "Valid Code" do
      it_behaves_like 'a valid request'

      it 'should return a list of viewers from the specified browser' do
        viewers
        get endpoint, params: { code: link.code, browser: "Chrome" }
        expect(response.body).to include_json(message: "Success",
                                              code: link.code,
                                              api_version: "v1")
        data = JSON.parse(response.body)["data"]
        expect(data["viewers"].size).to eq(1)
      end
    end
  end
end