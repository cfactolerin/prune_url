describe LinksController do

  context 'GET index' do

    context "Without code params" do
      it 'should return 200' do
        get :index
        expect(response.status).to eq(200)
      end

      it 'should assign a new @link record' do
        get :index
        expect(assigns(:link)).to be_a(Link)
        expect(assigns(:link)).to be_new_record
      end
    end

    context "With valid code params" do
      let(:link) { create(:link) }

      it 'should return 200' do
        get :index, params: {code: link.code}
        expect(response.status).to eq(200)
      end

      it 'should load the record to @link using the code param' do
        get :index, params: {code: link.code}
        expect(response.status).to eq(200)
        expect(assigns(:link)).to eq(link)
      end
    end

    context "With invalid code params" do
      let(:code) { "123456" }

      it 'should return 200' do
        get :index, params: {code: code}
        expect(response.status).to eq(200)
      end

      it 'should return a new @link record' do
        get :index, params: {code: code}
        expect(assigns(:link)).to be_a(Link)
        expect(assigns(:link)).to be_new_record
      end

      it 'should set a flash error' do
        get :index, params: {code: code}
        expect(flash[:error]).to eq("Invalid Code")
      end
    end
  end

  context "POST create" do

    context "Invalid URL" do
      let(:url) { "ssh://www.bleeh.com" }

      it 'should redirect to root_path' do
        post :create, params: {url: url}
        expect(response).to redirect_to(root_path)
      end

      it 'should set a flash error' do
        post :create, params: {url: url}
        expect(flash[:error]).to eq("Invalid URL")
      end

      it 'should work the same for empty url' do
        post :create, params: {url: ''}
        expect(flash[:error]).to eq("Invalid URL")
      end
    end

    context "Valid URL" do
      let(:url) { "www.cnn.com" }
      let(:link) { create(:link) }

      it 'should redirect to root_path' do
        post :create, params: {url: url}
        expect(response.location).to match(/http:\/\/test.host\/\?code=\w/)
      end

      it 'should create a new record for non-existing links' do
        expect(Link.all.size).to eq(0)
        post :create, params: { url: "https://www.cnn.com/page#{rand(1000)}" }
        expect(Link.all.size).to eq(1)
      end

      it 'should not create a new record for existing links' do
        link
        expect(Link.all.size).to eq(1)
        post :create, params: { url: link.original }
        expect(Link.all.size).to eq(1)
      end
    end

    context "Database can't be reached" do
      let(:url) { "www.cnn.com" }

      it 'should redirect to root_path' do
        allow(Link).to receive(:find_or_create).with(any_args).and_raise("DB connection issues")
        post :create, params: {url: url}
        expect(response).to redirect_to(root_path)
      end

      it 'should notify the user' do
        allow(Link).to receive(:find_or_create).with(any_args).and_raise("DB connection issues")
        post :create, params: {url: url}
        expect(flash[:error]).to eq(LinksController::ERROR_DB_CONNECTION)
      end
    end
  end

  context "GET visit" do
    let(:link) { create(:link) }

    context "Valid code" do
      it 'should redirect to the original link correctly if code is found' do
        get :visit, params: {code: link.code}
        expect(response).to redirect_to(link.original)
      end

      it "should record the viewer information" do
        expect(Viewer.all.size).to eq(0)
        get :visit, params: {code: link.code}
        expect(Viewer.all.size).to eq(1)
      end
    end

    context "Invalid Code" do
      it 'should return 404' do
        get :visit, params: {code: "12345"}
        expect(response.status).to eq(404)
      end
    end
  end
end