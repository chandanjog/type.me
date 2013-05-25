class RaceController < ApplicationController

    #GET
    def new
        race = find_or_create_an_available_race()
        return head :status => 404 if params[:user_id].blank?
        race.add_participant(params[:user_id])
        Races.add_or_update(race)
        return render :json =>race
    end

    #PUT
    def update
      race = Races.find_by_id params[:id]
      return head :status => 404 if race.nil?
      return head :status => 404 if params[:user_id].blank? || params[:progress].blank?
      race.participants[params[:user_id]] = {:progress => params[:progress]}
      Races.add_or_update(race)
      head 200
    end

    #GET
    def show
      race = Races.find_by_id(params[:id])
      return head :status => 404 if race.nil?
      render :json => race
    end

    private

    def find_or_create_an_available_race
      Races.find_available_race || Race.new
    end

end
