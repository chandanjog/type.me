class RaceController < ApplicationController

    #GET
    def new
        # Need to investigate stale parameter printing while logging for tests
        Rails.logger.info "********* user_id :: #{params[:user_id]}"
        race = Races.find_available_race || Race.new()
        race.add_participant(params[:user_id])
        Races.add_or_update(race)
        render :json => race
    end

    #PUT
    def update
      race = Races.find_by_id params[:id]
      return head :status => 404 if race.nil?
      return head :status => 404 if params[:user_id].blank? || params[:progress].blank?

      race.status = params[:status] if !params[:status].blank?
      race.update_participant(params[:user_id],params[:progress])
      Races.add_or_update(race)

      render :json => race
    end

    #GET
    def show
      race = Races.find_by_id(params[:id])
      return head :status => 404 if race.nil?
      render :json => race
    end

end
