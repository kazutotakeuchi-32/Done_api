require 'rails_helper'

RSpec.describe "DirectUploads", type: :request do
  describe "GET /direct_uploads" do
    it "works! (now write some real specs)" do
      get direct_uploads_path
      expect(response).to have_http_status(200)
    end
  end
end
