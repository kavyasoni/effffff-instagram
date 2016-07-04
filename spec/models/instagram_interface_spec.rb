describe InstagramInterface do
  describe "single_tag_data" do
    before :each do
      user = create(:user)
      tag  = 'word'
      interface = InstagramInterface.new(user.id, tag)
      @request  = interface.single_tag_data('word')
    end

    it "returns a hash of data" do
      expect(@request.class).to eq Hash
    end

    it "returns the hashtag name" do
      expect(@request[:data][:name]).to eq 'word'
    end

    it "returns the hashtag like count" do
      expect(@request[:data][:media_count]).to be < 4000
    end
  end

  describe "hashtag_media" do
    describe "without any arguments" do
      before :each do
        user = create(:user)
        tag  = 'word'
        interface = InstagramInterface.new(user.id, tag)
        @request  = interface.hashtag_media
      end

      it "returns a hash of data" do
        expect(@request.class).to eq Array
      end

      it "returns 10 fake objects" do
        expect(@request.length).to eq 10
      end

      it "returns tags all starting with the same letter" do
        @request.each do |request|
          request[:tags].each do |tag|
            expect(tag[0]).to eq 'c'
          end
        end
      end
    end

    describe "with a character argument" do
      before :each do
        user = create(:user)
        tag  = 'word'
        interface = InstagramInterface.new(user.id, tag)
        @request  = interface.hashtag_media 'c'
        @tags     = @request[0][:tags]
      end

      it "returns a hash of data" do
        expect(@request.class).to eq Array
      end

      it "returns 10 fake objects" do
        expect(@request.length).to eq 10
      end

      it "returns tags all starting with c" do
        letter = @tags[0][0]
        expect(letter).to eq 'c'
      end

      it "returns tags all starting with c" do
        @tags.map do |tag|
          expect(tag[0]).to eq 'c'
        end
      end
    end
  end
end