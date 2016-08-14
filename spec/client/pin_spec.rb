require 'spec_helper'

describe "Pinterest::Client::Pin" do

  before do
    @client = Pinterest::Client.new(ENV['ACCESS_TOKEN'])
  end

  describe 'POST /v1/pins/' do
    context "have the parameters for a pin" do
      it "should create a pin" do
        VCR.use_cassette("v1_create_pin") do
          response = @client.create_pin({
            board: '154178055932271277',
            note: 'Test from Ruby gem',
            link: 'https://www.shopseen.com',
            image_url: 'http://marketingland.com/wp-content/ml-loads/2014/07/pinterest-logo-white-1920.png',
          })
          expect(response.data.id).to be
          expect(response.data.link).to be
          expect(response.data.note).to eq('Test from Ruby gem')
          expect(response.data.url).to eq("http://pinterest.com/pin/#{response.data.id}/")
        end
      end
      context "with an image file" do
        it "should create a pin" do
          file_path = File.expand_path('') + "/spec/fixtures/images/test_image.png"
          VCR.use_cassette("v1_create_pin_with_image_file") do
            response = @client.create_pin({
              board: '1154178055932271277',
              note: 'Test from ruby gem',
              link: 'https://www.shopseen.com',
              image: Faraday::UploadIO.new(file_path, "image/png")
            })
            expect(response.data.keys).to match_array(
              ['id', 'link', 'note', 'url'])
          end
        end
      end
    end
    context "missing image for a pin" do
      it "should response with an error message" do
        VCR.use_cassette("v1_not_create_pin") do
          response = @client.create_pin({
            board: '154178055932271277',
            note: 'Test from Ruby gem',
            link: 'https://www.shopseen.com',
          })
          expect(response.message).to be
        end
      end
    end
  end

  describe 'PATCH /v1/pins/' do
    context "have the parameters for a pin" do
      it "should update a pin" do
        VCR.use_cassette("v1_update_pin") do
          response = @client.update_pin({
            id: '154177987221106968',
            note: "Test from Ruby gem at #{Time.now.to_s}"
          })
          expect(response.data.id).to be
        end
      end
    end
    context "missing image for a pin" do
      it "should response with an error message" do
        VCR.use_cassette("v1_not_update_pin") do
          response = @client.update_pin({
            id: '123',
            note: "Test from Ruby gem at #{Time.now.to_s}"
          })
          expect(response.message).to be
        end
      end
    end

  end

  describe 'GET /v1/pins/<pin_id>/' do
    context "the pin exists" do
      it "should get the pin" do
        VCR.use_cassette("v1_pin") do
          response = @client.get_pin('154177987221106992')
          expect(response.data.keys).to match_array(['id', 'link', 'note', 'url'])
        end
      end
    end
    context "the pin does not exist" do
      it "should respond with an error" do
        VCR.use_cassette("v1_no_pin") do
          response = @client.get_pin('123')
          expect(response.message).to be
        end
      end
    end
  end

  describe 'GET /v1/boards/<board_id>/pins/' do
    it "should get the board's pins" do
      VCR.use_cassette("v1_boards_pins") do
        response = @client.get_board_pins('154178055932402553')
        expect(response.data.class).to eq(Array)
      end
    end
  end

  describe 'DELETE /v1/pins/<pin_id>/' do
    context "the pin exists" do
      it "should delete a pin" do
        VCR.use_cassette("v1_delete_pin") do
          response = @client.delete_pin('154177987221106882')
          expect(response).to have_key(:data)
          expect(response.data).to be_falsey
          # TODO use response code
          # will need to spit it out from response
          # not finding a pin will have data: null
          # just like successfully deleting a pin
          # only difference is 404
        end
      end
    end
    context "the pin does not exist" do
      it "should response with an error message" do
        VCR.use_cassette("v1_not_delete_pin") do
          response = @client.delete_pin('123')
          expect(response.message).to be
        end
      end
    end
  end

end
