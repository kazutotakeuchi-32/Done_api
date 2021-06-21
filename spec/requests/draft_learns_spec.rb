require 'rails_helper'

RSpec.describe "DraftLearns", type: :request do
  describe "GET /draft_learns" do
    it "works! (now write some real specs)" do
      get draft_learns_path
      expect(response).to have_http_status(200)
    end
  end
end
