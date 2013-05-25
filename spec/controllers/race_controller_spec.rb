require 'spec_helper'


describe RaceController do
  context "GET #new"  do
    it "should create a new race if no AVAILABLE race(race in progress and haven't reached max participants) exists and add participant" do
      get :new, user_id: "foo"

      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "should update an existing AVAILABLE with participant"
  end
end