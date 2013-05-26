require 'ostruct'
require 'spec_helper'

describe RaceController do

  after(:each) do
    $redis.flushall
    configatron.race.max_participants = 2
  end

  context "GET #new"  do

    it :should_return_404_when_user_id_is_null_or_empty do
      get :new
      expect(response.status).to eq(404)
    end

    it :should_create_a_new_race_for_the_player_when_no_race_is_available_to_join do
      get :new, user_id: "foo"

      expect(response).to be_success
      expect(response.status).to eq(200)

      body = OpenStruct.new(JSON.parse(response.body))
      expect(body.participants.keys.size).to eq(1)
      expect(body.participants["foo"]).to eq({ "progress" => 0})
    end

    it :should_update_an_existing_race_with_participant_when_available do
      get :new, user_id: "foo"
      get :new, user_id: "boo"

      expect(response).to be_success
      expect(response.status).to eq(200)

      body = OpenStruct.new(JSON.parse(response.body))
      # a lower value of max participants allowed for a race is configured for tests
      expect(body.participants.keys.size).to eq(2)
      expect(body.participants["foo"]).to eq({ "progress" => 0})
      expect(body.participants["boo"]).to eq({ "progress" => 0})
    end

    it :should_create_a_new_race_when_races_with_open_slots_for_participants_are_not_available do
      configatron.race.max_participants = 2
      get :new, user_id: "foo"
      get :new, user_id: "boo"
      get :new, user_id: "baz"

      expect(response).to be_success
      expect(response.status).to eq(200)

      expect(Races.all.count).to eq(2)

      body = OpenStruct.new(JSON.parse(response.body))
      expect(body.participants.keys.size).to eq(1)
      expect(body.participants["baz"]).to_not eq(nil)
      expect(body.participants["baz"]).to eq({ "progress" => 0})
    end

    it :should_create_a_new_race_when_races_time_to_join_an_available_race_has_elapsed do
      configatron.race.max_participants = 3
      get :new, user_id: "foo"
      get :new, user_id: "boo"

      sleep(configatron.race.available.to.join.for.in.seconds.to_i + 2)

      get :new, user_id: "baz"

      expect(Races.all.count).to eq(2)

      expect(response).to be_success
      expect(response.status).to eq(200)
      body = OpenStruct.new(JSON.parse(response.body))
      expect(body.participants.keys.size).to eq(1)
      expect(body.participants["baz"]).to_not eq(nil)
      expect(body.participants["baz"]).to eq({ "progress" => 0})

    end

  end

  context "PUT #update" do
    it :should_return_404_when_race_does_not_exist do
      put :update, {:id => 1}
      expect(response.status).to eq(404)
    end

    it :should_return_404_when_user_does_not_exist_for_the_race do
      get :new, user_id: "foo"
      put :update, {:id => 1}

      expect(response.status).to eq(404)
    end

    it :should_return_404_when_progress_for_a_user_is_not_passed_for_the_race do
      get :new, user_id: "foo"
      put :update, {:id => 1}

      expect(response.status).to eq(404)
    end

    it :should_update_the_race_with_user_progress do
      get :new, user_id: "foo"
      body = OpenStruct.new(JSON.parse(response.body))
      expect(body.participants["foo"]).to eq({ "progress" => 0})

      put :update, {:id => 1, :user_id => "foo", :progress => 20}
      expect(response).to be_success
      expect(response.status).to eq(200)

      get :show, :id => 1
      body = OpenStruct.new(JSON.parse(response.body))
      expect(body.participants["foo"]).to eq({ "progress" => "20"})
    end
  end

  context "GET #show" do
    it :should_return_404_when_race_does_not_exist do
      get :show, :id => 1

      expect(response.status).to eq(404)
    end

    it :should_return_200_with_race_details_when_race_exists do
      get :new, user_id: "foo"
      get :show, :id => 1

      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end
end